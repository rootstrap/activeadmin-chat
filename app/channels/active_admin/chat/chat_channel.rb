module ActiveAdmin
  module Chat
    class ChatChannel < ApplicationCable::Channel
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

        ChatChannel.broadcast_to(conversation, ActiveAdmin::Chat::MessagePresenter.new(message))
      end

      private

      def conversation
        @conversation ||= if current_user.instance_of?(ActiveAdmin::Chat.admin_user_klass)
                            params[:conversation_id] &&
                              ActiveAdmin::Chat.conversation_klass.find_by(
                                id: params[:conversation_id]
                              )
                          elsif current_user.instance_of?(ActiveAdmin::Chat.user_klass)
                            ActiveAdmin::Chat.conversation_klass.find_by(
                              "#{ActiveAdmin::Chat.user_relation_name}_id": current_user.id
                            )
                          end
      end
    end
  end
end
