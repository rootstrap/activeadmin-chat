$(function() {
  _reframeTime();
  _scrollConversationToBottom();
  _subscribeChannel();

  $('#send-message').on('keypress', function(event) {
    if (event.which === 13) {
      _sendMessage.call(this, event);
    }
  });

  function _reframeTime() {
    $('.active-admin-chat__message-container').each(function(index, object) {
      var date = new Date($(object).attr('data-time'));
      var realTime = formatDate(date);
      $(object).children().append(`<span>${realTime}</span>`);
    })
  }

  function _scrollConversationToBottom() {
    var height = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
    $('.active-admin-chat__conversation-history').scrollTop(height);
  }

  function _insertMessage(message) {
    $('.active-admin-chat__conversation-history.no-messages').remove();
    var realTime = formatDate(new Date());
    var message2 = $(message).clone();
    message2.children().append(`<span>${realTime}</span>`);
    $('.active-admin-chat__conversation-history').append(message2);
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
  function formatDate(date){
    var reg = /(.+), (\d{2}):(\d{2}):(\d{2})/;
    var matches = date.toLocaleString('en-US', { hour12: false }).match(reg);
    return matches[2] + ':' + matches[3] + ' - ' + matches[1];
  }
});

