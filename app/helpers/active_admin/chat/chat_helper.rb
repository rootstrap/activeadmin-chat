module ActiveAdmin
  module Chat
    module ChatHelper
      def admin_class(message)
        'admin' if message.sender.class == ActiveAdmin::Chat.admin_user_klass
      end

      def selected_class(conversation, active_conversation)
        'selected' if active_conversation && active_conversation == conversation
      end
    end
  end
end
