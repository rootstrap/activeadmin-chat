module ActiveAdminChat
  class Application
    attr_accessor :conversation_model_name, :message_model_name, :admin_user_model_name,
                  :user_model_name

    def initialize
      @conversation_model_name = 'conversation'
      @message_model_name = 'message'
      @admin_user_model_name = 'admin_user'
      @user_model_name = 'user'
    end
  end
end
