class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation ? stream_for(conversation) : reject
  end

  def speak(data)
    message = conversation.public_send(ActiveAdminChat.message_relation_name.pluralize).create!(
      sender: current_user,
      content: data['message']
    )

    ChatChannel.broadcast_to(conversation, render_message_partial(message))
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

  def render_message_partial(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end
