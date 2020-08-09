class ChatComponent < ViewComponent::Base
  include Motion::Component

  attr_reader :user, :conversation, :messages, :send_message_id
  map_motion :send_message

  def initialize(user:, conversation:, messages:)
    @user = user
    @conversation = conversation
    @messages = messages
    @send_message_id = SecureRandom.uuid
  end

  def send_message(event)
    message = conversation.public_send(
      ActiveAdmin::Chat.message_relation_name.pluralize
    ).create!(
      sender: user,
      content: event.form_data[:message]
    )

    @messages << message
    @send_message_id = SecureRandom.uuid

    message = ActiveAdmin::Chat::MessagePresenter.new(message)
    ActiveAdmin::Chat::AdminChannel.broadcast_to(conversation, message)
    ActiveAdmin::Chat::UserChannel.broadcast_to(conversation, message)
  end
end
