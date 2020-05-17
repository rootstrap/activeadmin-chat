$(function() {
  ////////////////////
  // Initialization //
  ////////////////////

  _reframeTime();
  _scrollConversationToBottom();
  _subscribeChannel();
  var gettingNewMessages = false;

  /////////////////////
  // Event listeners //
  /////////////////////

  $('#send-message').on('keypress', function(event) {
    if (event.which === 13) { _sendMessage.call(this, event); }
  });

  $('.active-admin-chat__conversation-history').on('scroll', function() {
    if ($(this).scrollTop() === 0 && !gettingNewMessages) {
      gettingNewMessages = true;
      var urlParam = '?created_at=' + _getOlderDate().toString();
      $.ajax({
        type: 'GET',
        url: window.location.href.split('?')[0] + urlParam,
        dataType: 'json',
        context: this,
        success: function(data) {
          var currentTopElement = $(this).children().first();
          for (var i = 0; i < data.operations.length; i++) {
            var op = data.operations[i];
            $(op.selector)[0][op.name](op.position, op.html);
          }
          _reframeTime();
          var previousHeight = 0;
          currentTopElement.prevAll().each(function() {
            previousHeight += $(this).outerHeight();
          });
          $(this).scrollTop(previousHeight);
          gettingNewMessages = false;
        }
      });
    }
  });

  //////////////////////
  // Helper functions //
  //////////////////////

  function _getConversationId() {
    var conversation = $('.active-admin-chat__conversation-item.selected').attr('id');
    return conversation.split('-')[1];
  }

  function _getOlderDate() {
    var date = $('.active-admin-chat__conversation-history').children().first().data('time');
    return new Date(date);
  }

  function _scrollConversationToBottom() {
    var height = $('.active-admin-chat__conversation-history').get(0).scrollHeight;
    $('.active-admin-chat__conversation-history').animate({ scrollTop: height }, { duration: 'fast' });
  }

  function _sendMessage(event) {
    var inputValue = $(this).val();
    if (inputValue) {
      ActiveAdminChat.conversation.sendMessage(inputValue);
      $(this).val('');
    }
  };

  function _subscribeChannel() {
    ActiveAdminChat.conversation = ActiveAdminChat.cable.subscriptions.create({
      channel: 'ActiveAdminChat::AdminChatChannel',
      conversation_id: _getConversationId()
    }, {
      received: function(data) {
        CableReady.perform(data.operations);
        _reframeTime();
        _scrollConversationToBottom();
      },
      sendMessage: function(data) {
        this.perform('speak', { message: data });
      },
    });
  };

  function _reframeTime() {
    $('.active-admin-chat__message-container').filter(function() {
      return !($(this).children().children().is('.active-admin-chat__time'));
    }).each(function(index, object) {
      if (object.childNodes.length) { _addTime(object); }
    })
  }

  function _addTime(element) {
    var date = new Date($(element).data('time'));
    var realTime = _formatDate(date);
    $(element).children().append("<span class='active-admin-chat__time'>" + realTime + '</span>');
  }

  function _formatDate(date) {
    var reg = /(.+), (\d{2}):(\d{2}):(\d{2})/;
    var matches = date.toLocaleString('en-US', { hour12: false }).match(reg);
    return matches[2] + ':' + matches[3] + ' - ' + matches[1];
  }
});
