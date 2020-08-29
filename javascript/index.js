import createSubscription from './modules/createSubscription';
import 'motion' from './modules/motion';
import reframeTime from './modules/reframeTime';
import scrollConversationToBottom from './modules/scrollConversationToBottom';
import setScrollListener from './modules/setScrollListener';
import setSendMessageListener from './modules/setSendMessageListener';

document.addEventListener('DOMContentLoaded', () => {
  reframeTime();
  scrollConversationToBottom();
  const channelSubscription = createSubscription();
  setSendMessageListener(channelSubscription);
  setScrollListener();
});
