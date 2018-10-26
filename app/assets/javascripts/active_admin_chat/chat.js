$(function() {
  $(document).on('click', '.active-admin-chat__conversation-item', function() {
     _loadConversationHistory.call(this, this.id.split('-')[1]);
  });

  function _loadConversationHistory(conversationId) {
    $('.active-admin-chat__conversation-item').removeClass('selected');

    $.ajax({
      type: 'GET',
      url: ActiveAdminChat.conversationEndpoint + conversationId,
      dataType: 'json',
      context: this,
      success: function(data) {
        $(this).addClass('selected');
        $('.active-admin-chat__conversation-history').empty();
        $.each(data.messages, function(i, message) {
          _prependMessage(message);
        });
        $('.active-admin-chat__conversation-history').scrollTop($('.active-admin-chat__conversation-history').get(0).scrollHeight);
      },
      error: function(xhr, status, error) {
        $('.active-admin-chat__conversation-history').empty().append('<p> Messages could not be retrieved <p>')
      }
    });
  };

  function _prependMessage(message) {
    var adminClass = message.is_admin ? 'admin' : '';
    var date = new Date(message.date);
    var formattedDate = date.toLocaleTimeString() + ' ' + date.toLocaleDateString();

    $('.active-admin-chat__conversation-history').prepend(
      "<div id='message-" + message.id + "' class='active-admin-chat__message-container " + adminClass + "'>" +
        "<p>" + message.message +  "<span class='active-admin-chat__time'>" + formattedDate + "</span></p>" +
      "</div>"
    );
  };
});
