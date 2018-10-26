$(function() {
  _scrollConversationToBottom();

  function _scrollConversationToBottom() {
    $('.active-admin-chat__conversation-history').scrollTop($('.active-admin-chat__conversation-history').get(0).scrollHeight);
  }
});
