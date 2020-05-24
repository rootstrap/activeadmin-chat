ActiveAdmin::Chat.setup do |config|
  # Specify the names of the models required for the chat
  config.conversation_model_name = 'conversation'
  config.message_model_name = 'message'
  config.admin_user_model_name = 'admin_user'
  config.user_model_name = 'user'
  config.messages_per_page = 25
end
