module ActiveAdminChat
  module ActiveAdmin
    module Application
      def register_chat(name, options = {}, &block)
        setup_page_configs(name, options[:namespace])

        register_page name, options do
          content do
            conversations = ActiveAdminChat.conversation_klass
                                           .includes(ActiveAdminChat.user_relation_name)
                                           .all

            render 'chat/chat', conversations: conversations
          end

          controller do
            layout 'active_admin', only: :show
            helper_method :messages, :conversation

            def show
              conversations = ActiveAdminChat.conversation_klass
                                             .includes(ActiveAdminChat.user_relation_name)
                                             .all

              render 'chat/show', locals: { conversations: conversations }
            end

            def conversation
                @conversation ||= ActiveAdminChat.conversation_klass.find(params[:id])
            end

            def messages
              conversation&.public_send(ActiveAdminChat.message_relation_name.pluralize)
                .includes(:sender).order(created_at: :asc)
            end
          end

          # customize default chat
          instance_eval(&block)
        end
      end

      private

      def setup_page_configs(page_name, namespace)
        ActiveAdminChat.setup do |config|
          config.page_name = page_name.downcase
          config.namespace = namespace.downcase if namespace
        end
      end
    end
  end
end
