module ActiveAdminChat
  module ActiveAdmin
    module Application
      def register_chat(name, options = {}, &block)
        register_page name, options do
          content do
            @conversations = ActiveAdminChat.conversation_klass
                                            .includes(ActiveAdminChat.user_relation_name)
                                            .all

            render 'chat/chat', conversations: @conversations
          end

          # customize default chat
          instance_eval(&block)
        end
      end
    end
  end
end
