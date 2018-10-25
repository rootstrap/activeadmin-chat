$(function() {
  $(document).on('click', '.active-admin-chat__conversation-item', function() {
     $('#send-message').show();

     if (!$(this).hasClass('selected')) {
       _loadConversationHistory.call(this, this.id.split('-')[1]);
     }
  });

  $('#send-message').on('keypress', function(event) {
    if (event.which === 13) {
      _sendMessage.call(this, event);
    }
  });

  function _loadConversationHistory(conversationId) {
    $('.active-admin-chat__conversation-item').removeClass('selected');

    _openConversation(conversationId);

    $.ajax({
      type: 'GET',
      url: ActiveAdminChat.conversationEndpoint + conversationId,
      dataType: 'json',
      context: this,
      success: function(data) {
        $(this).addClass('selected');
        $('.active-admin-chat__conversation-history').empty();
        $.each(data.messages, function(i, message) {
          _insertMessage(message, true);
        });
        $('.active-admin-chat__conversation-history').scrollTop($('.active-admin-chat__conversation-history').get(0).scrollHeight);
      },
      error: function(xhr, status, error) {
        $('.active-admin-chat__conversation-history').empty().append('<p> Messages could not be retrieved <p>')
      }
    });
  };

  function _insertMessage(message, prepend) {
    var adminClass = message.is_admin ? 'admin' : '';
    var date = new Date(message.date);
    var formattedDate = date.toLocaleTimeString() + ' ' + date.toLocaleDateString();
    var messageHTML = "<div id='message-" + message.id + "' class='active-admin-chat__message-container " + adminClass + "'>" +
                        "<p>" + message.message +  "<span class='active-admin-chat__time'>" + formattedDate + "</span></p>" +
                      "</div>";

    if (prepend) {
      $('.active-admin-chat__conversation-history').prepend(messageHTML);
    } else {
      $('.active-admin-chat__conversation-history').append(messageHTML);
    }
  };

  function _sendMessage(event) {
    var inputValue = $(this).val();
    ActiveAdminChat.conversation.sendMessage(inputValue);
    $(".active-admin-chat__conversation-history").animate({ scrollTop: $(".active-admin-chat__conversation-history").get(0).scrollHeight });
    $(this).val('');
  };

  function _openConversation(conversationId) {
    if (ActiveAdminChat.conversation) {
      ActiveAdminChat.cable.subscriptions.remove(ActiveAdminChat.conversation);
    }

    ActiveAdminChat.conversation = ActiveAdminChat.cable.subscriptions.create({
      channel: 'ChatChannel',
      conversation_id: conversationId
    }, {
      received: function(data) {
        _insertMessage(data, false);
      },
      sendMessage: function(data) {
        this.perform('speak', { message: data });
      },
    });
  };
});
