import formatDate from '../formatDate';

export default (message) => {
  return `
    <div id='message-${message.id}' data-time='${message.date}' class='active-admin-chat__message-container ${message.is_admin ? 'admin' : ''}'>
      <div>
        <p>${message.message}</p>
          <span class='active-admin-chat__time'>${formatDate(new Date(message.date))}</span>
      </div>
    </div>
  `;
};
