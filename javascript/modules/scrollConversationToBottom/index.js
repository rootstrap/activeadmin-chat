export default () => {
  const conversationHistory = document.querySelector('.active-admin-chat__conversation-history');
  conversationHistory.scrollTop = conversationHistory.scrollHeight;
};
