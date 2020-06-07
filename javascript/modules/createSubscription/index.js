import { createConsumer } from '@rails/actioncable';
import messageToHtml from '../messageToHtml';
import reframeTime from '../reframeTime';
import scrollConversationToBottom from '../scrollConversationToBottom';

const conversationId = () => {
  return document.querySelector('.active-admin-chat__conversation-item.selected').getAttribute('id').split('-')[1];
};

const insertMessage = (message) => {
  const emptyState = document.querySelector('.active-admin-chat__conversation-history.no-messages')
  if (emptyState) { emptyState.remove(); }
  document.querySelector('.active-admin-chat__conversation-history').insertAdjacentHTML('beforeend', messageToHtml(message));
};

export default () => {
  return createConsumer().subscriptions.create({
    channel: 'ActiveAdmin::Chat::AdminChannel',
    conversation_id: conversationId()
  }, {
    received(data) {
      insertMessage(data);
      reframeTime();
      scrollConversationToBottom();
    },
    sendMessage(data) {
      this.perform('speak', { message: data });
    }
  });
};
