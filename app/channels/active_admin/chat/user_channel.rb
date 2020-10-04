module ActiveAdmin
  module Chat
    class UserChannel < ActiveAdmin::Chat::BaseChannel
      private

      def conversation
        return unless user?

        @conversation ||= ActiveAdmin::Chat.conversation_klass.find_by(
          "#{ActiveAdmin::Chat.user_relation_name}_id": current_user.id
        )
      end

      def user?
        current_user.instance_of?(ActiveAdmin::Chat.user_klass)
      end
    end
  end
end
