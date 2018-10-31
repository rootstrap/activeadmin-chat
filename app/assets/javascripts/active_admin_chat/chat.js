$(function() {
  /////////////////////
  // Event Listeners //
  /////////////////////

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


  $('.active-admin-chat__conversation-history').on('scroll', function() {
    _scrollConversation.call(this);
  });

  ///////////////////////
  // Private Functions //
  ///////////////////////

  function _loadConversationHistory(conversationId) {
    $('.active-admin-chat__conversation-item').removeClass('selected');

    _openConversation(conversationId);
    ActiveAdminChat.currentPage = 1;
    ActiveAdminChat.conversationId = conversationId;

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
    if (!$('#message-' + message.id).length) {
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

  function _scrollConversation() {
    if ($(this).scrollTop() === 0) {
      ActiveAdminChat.currentPage++;

      $.ajax({
        type: 'GET',
        url: ActiveAdminChat.conversationEndpoint + ActiveAdminChat.conversationId,
        dataType: 'json',
        data: {
          page: ActiveAdminChat.currentPage
        },
        context: this,
        success: function(data) {
          var currentTopElement = $(this).children().first();

          $.each(data.messages, function(i, message) {
            _insertMessage(message, true);
          });

          var previousHeight = 0;
          currentTopElement.prevAll().each(function() {
            previousHeight += $(this).outerHeight();
          });

          $(this).scrollTop(previousHeight);
        }
      });
    }
  };
});
