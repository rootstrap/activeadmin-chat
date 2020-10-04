module ActiveAdmin
  module Chat
    class BaseChannel < ApplicationCable::Channel
      def subscribed
        conversation ? stream_for(conversation) : reject
      end

      def speak(data)
        message = conversation.public_send(
          ActiveAdmin::Chat.message_relation_name.pluralize
        ).create!(
          sender: current_user,
          content: data['message']
        )

        message = ActiveAdmin::Chat::MessagePresenter.new(message)
        ActiveAdmin::Chat::AdminChannel.broadcast_to(conversation, message)
        ActiveAdmin::Chat::UserChannel.broadcast_to(conversation, message)
      end

      private

      def conversation
        raise NotImplementedError
      end
    end
  end
end
