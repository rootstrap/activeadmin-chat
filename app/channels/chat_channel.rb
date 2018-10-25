class ChatChannel < ApplicationCable::Channel
  def subscribed
    if conversation
      stream_for conversation
    else
      reject
    end
  end

  def speak(data)
    message = conversation.public_send(ActiveAdminChat.message_relation_name.pluralize).create!(
      sender: current_user,
      content: data['message']
    )

    ChatChannel.broadcast_to(conversation, ActiveAdminChat::MessagePresenter.new(message))
  end

  private

  def conversation
    @conversation ||= if current_user.instance_of?(ActiveAdminChat.admin_user_klass)
                        params[:conversation_id] &&
                          ActiveAdminChat.conversation_klass.find_by_id(params[:conversation_id])
                      else
                        ActiveAdminChat.conversation_klass.find_by(
                          "#{ActiveAdminChat.user_relation_name}_id": current_user.id
                        )
                      end
  end
end
