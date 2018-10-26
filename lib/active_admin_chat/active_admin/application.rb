module ActiveAdminChat
  module ActiveAdmin
    module Application
      def register_chat(name, options = {}, &block)
        register_page name, options do
          # add chat defaults here

          # customize default chat
          instance_eval(&block)
        end
      end
    end
  end
end
