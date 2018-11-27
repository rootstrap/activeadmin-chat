module ActiveAdminChat
  module ActiveAdmin
    module Application
      def register_chat(name, options = {}, &block)
        setup_page_configs(name, options[:namespace])

        register_page name, options do
          content do
            render 'chat/chat'
          end

          controller do
            layout 'active_admin', only: :show
            helper_method :messages, :active_conversation, :conversations

            def show
              respond_to do |format|
                format.html { render 'chat/show' }
                format.json do
                  render json: { messages: render_messages_partial }
                end
              end
            end

            def create
              conversation = ActiveAdminChat.conversation_klass
                                            .find_or_create_by!(
                                              "#{user_relation_name_id}": params[:"#{user_relation_name_id}"]
                                            )
              redirect_to action: 'show', id: conversation
            end

            def active_conversation
              @active_conversation ||= ActiveAdminChat.conversation_klass.find_by(id: params[:id])
            end

            def conversations
              @conversations ||= ActiveAdminChat.conversation_klass
                                                .includes(ActiveAdminChat.user_relation_name)
            end

            def messages
              return [] unless active_conversation

              page_messages = active_conversation.public_send(ActiveAdminChat
                                                              .message_relation_name
                                                              .pluralize)
                                                 .includes(:sender).order(created_at: :desc)

              if params[:created_at].present?
                page_messages = page_messages.where('created_at < ?', DateTime.parse(params[:created_at]))
              end
              page_messages.limit(ActiveAdminChat.messages_per_page).reverse
            end

            private

            def render_messages_partial
              ApplicationController.render(
                partial: 'messages/messages',
                locals: { messages: messages }
              )
            end

            def user_relation_name_id
              "#{ActiveAdminChat.user_relation_name}_id"
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
