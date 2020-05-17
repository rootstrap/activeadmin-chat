$(function() {
  _reframeTime($('.active-admin-chat__message-container'));
  _scrollConversationToBottom();
  _subscribeChannel();
  var gettingNewMessages = false;

  $('#send-message').on('keypress', function(event) {
    if (event.which === 13) {
      _sendMessage.call(this, event);
    }
  });

  function _reframeTime(messages) {
    messages.each(function(index, object) {
      if (object.childNodes.length != 0){
        _addTime(object);
      }
    })
  }

  $('.active-admin-chat__conversation-history').on('scroll', function() {
    if ($(this).scrollTop() === 0) {
      if (!gettingNewMessages) {
        gettingNewMessages = true;
        var urlParam = '?created_at=' + (_getOlderDate().toString());
        $.ajax({
          type: 'GET',
          url: window.location.href.split('?')[0] + urlParam,
          dataType: 'json',
          context: this,
          success: function(data) {
            var currentTopElement = $(this).children().first();
            $('.active-admin-chat__conversation-history').prepend(data.messages.map(function(message){
              return _messageToHtml(message);
            }));
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
    var date = $('.active-admin-chat__conversation-history').children().first().data('time')
    return new Date(date);
  }

  function _scrollConversationToBottom() {
    var height = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
    $('.active-admin-chat__conversation-history').scrollTop(height);
  }

  function _insertMessage(message) {
    $('.active-admin-chat__conversation-history.no-messages').remove();
    $('.active-admin-chat__conversation-history').append(_messageToHtml(message));
  };

  function _messageToHtml(message) {
    var adminClass = message.is_admin ? 'admin' : '';
    var messageHTML = "<div id='message-" + message.id + "' data-time='" + message.date +"' class='active-admin-chat__message-container " + adminClass + "'>" +
                        "<div>" +
                          "<p>" + message.message + "</p>" +
                          "<span class='active-admin-chat__time'>" + formatDate(new Date(message.date)) + "</span>" +
                        "</div>" +
                      "</div>";
    return messageHTML;
  }

  function _sendMessage(event) {
    var inputValue = $(this).val();
    if (inputValue) {
      ActiveAdminChat.conversation.sendMessage(inputValue);
      var scrollHeight = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
      $('.active-admin-chat__conversation-history').animate({ scrollTop: scrollHeight });
      $(this).val('');
    }
  };

  function _getConversationId() {
    var conversation = $('.active-admin-chat__conversation-item.selected').attr('id');
    return conversation.split('-')[1];
  }

  function _subscribeChannel() {
    ActiveAdminChat.conversation = ActiveAdminChat.cable.subscriptions.create({
      channel: 'ActiveAdminChat::AdminChatChannel',
      conversation_id: _getConversationId()
    }, {
      received: function(data) {
        if (data.cableReady) {
          CableReady.perform(data.operations);
        } else {
          _insertMessage(data);
        }
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
