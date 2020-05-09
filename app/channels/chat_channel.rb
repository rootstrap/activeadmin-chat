require 'cable_ready'

class ChatChannel < ApplicationCable::Channel
  include ::CableReady::Broadcaster

  def subscribed
    conversation ? stream_for(conversation) : reject
  end

  def speak(data)
    message = conversation.public_send(ActiveAdminChat.message_relation_name.pluralize).create!(
      sender: current_user,
      content: data['message']
    )

    cable_ready["chat:#{broadcasting_for(conversation)}"].insert_adjacent_html(
      selector: ".active-admin-chat__conversation-history",
      position: "beforeend",
      html: "<p>#{data['message']}</p>"
    )
    cable_ready.broadcast
  end

  private

  def conversation
    @conversation ||= if current_user.instance_of?(ActiveAdminChat.admin_user_klass)
                        params[:conversation_id] &&
                          ActiveAdminChat.conversation_klass.find_by(id: params[:conversation_id])
                      elsif current_user.instance_of?(ActiveAdminChat.user_klass)
                        ActiveAdminChat.conversation_klass.find_by(
                          "#{ActiveAdminChat.user_relation_name}_id": current_user.id
                        )
                      end
  end
end
