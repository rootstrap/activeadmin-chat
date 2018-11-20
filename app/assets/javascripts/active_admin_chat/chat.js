$(function() {
  _scrollConversationToBottom();
  _subscribeChannel();

  $('#send-message').on('keypress', function(event) {
    if (event.which === 13) {
      _sendMessage.call(this, event);
    }
  });

  function _scrollConversationToBottom() {
    var height = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
    $('.active-admin-chat__conversation-history').scrollTop(height);
  }

  function _insertMessage(message) {
    $('.active-admin-chat__conversation-history.no-messages').remove();
    $('.active-admin-chat__conversation-history').prepend(message);
  };

  function _sendMessage(event) {
    var inputValue = $(this).val();
    if (inputValue) {
      ActiveAdminChat.conversation.sendMessage(inputValue);
      $('.active-admin-chat__conversation-history').animate({ scrollTop: $('.active-admin-chat__conversation-history').get(0).scrollHeight });
      $(this).val('');
    }
  };

  function _subscribeChannel() {
    var conversation = $('.active-admin-chat__conversation-item.selected').attr('id');
    var conversationId = conversation.split('-')[1];

    ActiveAdminChat.conversation = ActiveAdminChat.cable.subscriptions.create({
      channel: 'ChatChannel',
      conversation_id: conversationId
    }, {
      received: function(data) {
        _insertMessage(data);
      },
      sendMessage: function(data) {
        this.perform('speak', { message: data });
      },
    });
  };
});

