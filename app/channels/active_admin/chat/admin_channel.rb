module ActiveAdmin
  module Chat
    class AdminChannel < ActiveAdmin::Chat::BaseChannel
      private

      def conversation
        return unless admin? && conversation_id.present?

        @conversation ||= ActiveAdmin::Chat.conversation_klass.find_by(id: conversation_id)
      end

      def admin?
        current_user.instance_of?(ActiveAdmin::Chat.admin_user_klass)
      end

      def conversation_id
        params[:conversation_id]
      end
    end
  end
end
