class ChatComponent < ViewComponent::Base
  include Motion::Component

  attr_reader :user, :conversation, :messages, :send_message_id

  def initialize(user:, conversation:, messages:)
    @user = user
    @conversation = conversation
    @messages = messages
    @send_message_id = SecureRandom.uuid

    stream_for(conversation, :handle_received)
  end

  map_motion :send_message
  def send_message(event)
    message = conversation.public_send(
      ActiveAdmin::Chat.message_relation_name.pluralize
    ).create!(
      sender: user,
      content: event.form_data[:message]
    )

    @send_message_id = SecureRandom.uuid

    self.class.broadcast_to(conversation, ActiveAdmin::Chat::MessagePresenter.new(message))
  end

  map_motion :load_messages
  def load_messages(_event)
    older_messages = conversation.public_send(ActiveAdmin::Chat.message_relation_name.pluralize)
                                 .includes(:sender)
                                 .where('created_at < ?', messages.first.created_at)
                                 .order(created_at: :desc)
                                 .limit(ActiveAdmin::Chat.messages_per_page)
                                 .reverse

    @messages = older_messages + @messages
  end

  def handle_received(message)
    @messages << conversation.public_send(
      ActiveAdmin::Chat.message_relation_name.pluralize
    ).includes(:sender).find(message['id'])
  end
end
