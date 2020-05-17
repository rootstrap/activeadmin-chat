require 'cable_ready'

module ActiveAdminChat
  class ApplicationChannel < ApplicationCable::Channel
    include ::CableReady::Broadcaster

    def subscribed
      conversation ? stream_for(conversation) : reject
    end

    def speak(data)
      message = conversation.public_send(ActiveAdminChat.message_relation_name.pluralize).create!(
        sender: current_user,
        content: data['message']
      )

      ActiveAdminChat::ChatChannel.broadcast_to(conversation, ActiveAdminChat::MessagePresenter.new(message))
      cable_ready["active_admin_chat:admin_chat:#{broadcasting_for(conversation)}"].insert_adjacent_html(
        selector: ".active-admin-chat__conversation-history",
          position: "beforeend",
          html: "<p>#{data['message']}</p>"
      )
      cable_ready.broadcast
    end

    private

    def conversation
      raise NotImplementedError
    end
  end
end
