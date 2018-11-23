$(function() {
  _reframeTime();
  _scrollConversationToBottom();
  _subscribeChannel();
  var olderDate;
  var gettingNewMessages = false;

  $('#send-message').on('keypress', function(event) {
    if (event.which === 13) {
      _sendMessage.call(this, event);
    }
  });

  function _reframeTime() {
    $('.active-admin-chat__message-container').each(function(index, object) {
      _addTime(object);
    })
  }

  $('.active-admin-chat__conversation-history').bind('scroll', function() {
    if($(this).scrollTop() == 0) {
      if (!gettingNewMessages) {
        gettingNewMessages = true;

        $.ajax({
          type: 'GET',
          url: ActiveAdminChat.conversationEndpoint + _getConversationId() + '?created_at=' + (_getOlderDate().toString()),
          dataType: 'json',
          context: this,
          success: function(data) {
            if (data.length) {
              olderDate = new Date($(data[0]).attr('data-time'));
            }
            var currentTopElement = $(this).children().first();
            $.each(data.reverse(), function(i, message) {
              var realTime = formatDate(new Date());
              var message2 = $(message).clone();
              message2.children().append('<span>'+ realTime + '</span>');
              $('.active-admin-chat__conversation-history').prepend(message2);
            });
            var previousHeight = 0;
            currentTopElement.prevAll().each(function() {
              previousHeight += $(this).outerHeight();
            });
            $(this).scrollTop(previousHeight);
            gettingNewMessages = false;
          }
        });
      }
    }
  })

  function _getOlderDate() {
    if (!olderDate) {
      $('.active-admin-chat__message-container').each(function(index, object) {
        var date = new Date($(object).attr('data-time'));
        if (!olderDate || (date < olderDate)) {
          olderDate = date;
        }
      });
    }
    return olderDate;
  }

  function _scrollConversationToBottom() {
    var height = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
    $('.active-admin-chat__conversation-history').scrollTop(height);
  }

  function _insertMessage(message) {
    $('.active-admin-chat__conversation-history.no-messages').remove();
    var messageDOM = $(message);
    _addTime(messageDOM);
    $('.active-admin-chat__conversation-history').append(messageDOM);
  };

  function _sendMessage(event) {
    var inputValue = $(this).val();
    if (inputValue) {
      ActiveAdminChat.conversation.sendMessage(inputValue);
      $('.active-admin-chat__conversation-history').animate({ scrollTop: $('.active-admin-chat__conversation-history').get(0).scrollHeight });
      $(this).val('');
    }
  };

  function _getConversationId(){
    var conversation = $('.active-admin-chat__conversation-item.selected').attr('id');
    return conversation.split('-')[1];
  }

  function _subscribeChannel() {
    ActiveAdminChat.conversation = ActiveAdminChat.cable.subscriptions.create({
      channel: 'ChatChannel',
      conversation_id: _getConversationId()
    }, {
      received: function(data) {
        _insertMessage(data);
      },
      sendMessage: function(data) {
        this.perform('speak', { message: data });
      },
    });
  };

  function formatDate(date) {
    var reg = /(.+), (\d{2}):(\d{2}):(\d{2})/;
    var matches = date.toLocaleString('en-US', { hour12: false }).match(reg);
    return matches[2] + ':' + matches[3] + ' - ' + matches[1];
  }

  function _addTime(element) {
    var date = new Date($(element).data('time'));
    var realTime = formatDate(date);
    $(element).children().append('<span>'+ realTime + '</span>');
  }
});
