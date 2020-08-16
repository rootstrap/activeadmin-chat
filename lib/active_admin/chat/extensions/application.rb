module ActiveAdmin
  module Chat
    module Extensions
      module Application
        def register_chat(name, options = {}, &block)
          setup_page_configs(name, options[:namespace])

          register_page name, options do
            content do
              render 'active_admin/chat/chat'
            end

            controller do
              layout 'active_admin', only: :show
              helper_method :messages, :active_conversation, :conversations

              def show
                respond_to do |format|
                  format.html { render 'active_admin/chat/show' }
                  format.json do
                    render json: ActiveAdmin::Chat::MessagePresenter.all(messages)
                  end
                end
              end

              def create
                conversation =
                  ActiveAdmin::Chat.conversation_klass
                                   .find_or_create_by!(
                                     "#{user_relation_name_id}": params[:"#{user_relation_name_id}"]
                                   )
                redirect_to action: 'show', id: conversation
              end

              def active_conversation
                @active_conversation ||=
                  ActiveAdmin::Chat.conversation_klass.find_by(id: params[:id])
              end

              def conversations
                @conversations ||= ActiveAdmin::Chat.conversation_klass
                                                    .includes(ActiveAdmin::Chat.user_relation_name)
              end

              def messages
                return [] unless active_conversation

                active_conversation.public_send(ActiveAdmin::Chat.message_relation_name.pluralize)
                                   .includes(:sender)
                                   .order(created_at: :desc)
                                   .limit(ActiveAdmin::Chat.messages_per_page)
                                   .reverse
              end

              private

              def user_relation_name_id
                "#{ActiveAdmin::Chat.user_relation_name}_id"
              end
            end

            # customize default chat
            instance_eval(&block)
          end
        end

        private

        def setup_page_configs(page_name, namespace)
          ActiveAdmin::Chat.setup do |config|
            config.page_name = page_name.downcase
            config.namespace = namespace.downcase if namespace
          end
        end
      end
    end
  end
end
