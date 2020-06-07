import formatDate from '../formatDate';

const addTime = (message) => {
  const date = new Date($(message).data('time'));
  message.children[0].insertAdjacentHTML('beforeend', `<span class='active-admin-chat__time'>${formatDate(date)}</span>`);
}

export default () => {
  const messages = document.querySelectorAll('.active-admin-chat__message-container');

  Array.prototype.filter.call(messages,
    (element) => !element.querySelector('.active-admin-chat__time')
  ).forEach((element) => addTime(element));
};
