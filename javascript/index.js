import reframeTime from './modules/reframeTime';
import scrollConversationToBottom from './modules/scrollConversationToBottom';

const conversationHistory = document.querySelector('.active-admin-chat__conversation-history');
const sendMessageForm = document.querySelector('.active-admin-chat__send-message-form');
let firstElement = null;
let loadingMessages = false;
let scrolling = false;

document.addEventListener('DOMContentLoaded', () => {
  reframeTime();
  scrollConversationToBottom();
});

document.addEventListener('motion:render', () => {
  reframeTime();

  if (loadingMessages) {
    loadingMessages = false;
    firstElement.scrollIntoView();
  } else if (!scrolling) {
    scrollConversationToBottom();
  }
});

conversationHistory.addEventListener('scroll', event => {
  if (conversationHistory.scrollTop) {
    scrolling = conversationHistory.scrollTop !== (conversationHistory.scrollHeight - conversationHistory.offsetHeight);
    event.stopImmediatePropagation();
  } else {
    loadingMessages = true;
    firstElement = conversationHistory.children[0];
  }
});

sendMessageForm.addEventListener('submit', () => {
  scrolling = false;
});

import motion from './modules/motion';
