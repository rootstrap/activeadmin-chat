module ActiveAdmin
  module Chat
    class MessagePresenter
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def self.all(messages)
        { messages: messages.map { |m| new(m) } }
      end

      def as_json(*)
        {
          id: message.id,
          message: message.content,
          date: message.created_at.iso8601(3),
          is_admin: message.sender.class == ActiveAdmin::Chat.admin_user_klass
        }
      end
    end
  end
end
