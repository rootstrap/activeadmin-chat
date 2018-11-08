$(function() {
  _scrollConversationToBottom();

  function _scrollConversationToBottom() {
    var height = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
    $('.active-admin-chat__conversation-history').scrollTop(height);
  }
});
