module ActiveAdminChat
  class Application
    attr_accessor :conversation_model_name, :message_model_name, :admin_user_model_name,
                  :user_model_name, :page_name, :namespace, :messages_per_page

    def initialize
      @conversation_model_name = 'conversation'
      @message_model_name = 'message'
      @admin_user_model_name = 'admin_user'
      @user_model_name = 'user'
      @namespace = 'admin'
      @messages_per_page = 25
    end

    %i[conversation message admin_user user].each do |attribute|
      define_method :"#{attribute}_klass" do
        public_send("#{attribute}_model_name").pluralize.classify.constantize
      end
    end

    %i[conversation message admin_user user].each do |attribute|
      define_method :"#{attribute}_relation_name" do
        public_send("#{attribute}_model_name").split('/').last
      end
    end
  end
end
