module ActiveAdminChat
  class ChatChannel < ActiveAdminChat::ApplicationChannel
    private

    def conversation
      @conversation ||= current_user.instance_of?(ActiveAdminChat.user_klass) &&
        ActiveAdminChat.conversation_klass.find_by(
          "#{ActiveAdminChat.user_relation_name}_id": current_user.id
      )
    end
  end
end
