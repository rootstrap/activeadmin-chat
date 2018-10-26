module ChatHelper
  def admin_class(message)
    'admin' if message.sender.class == ActiveAdminChat.admin_user_klass
  end
end
