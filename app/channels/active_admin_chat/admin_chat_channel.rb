module ActiveAdminChat
  class AdminChatChannel < ActiveAdminChat::ApplicationChannel
    private

    def conversation
      @conversation ||= current_user.instance_of?(ActiveAdminChat.admin_user_klass) &&
        params[:conversation_id] &&
        ActiveAdminChat.conversation_klass.find_by(id: params[:conversation_id])
    end
  end
end
