module ChatHelper
  def admin_class(message)
    'admin' if message.sender.class == ActiveAdminChat.admin_user_klass
  end

  def selected_class(conversation, active_conversation)
    'selected' if active_conversation && active_conversation == conversation
  end
end
