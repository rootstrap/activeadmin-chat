const formatDate = (date) => {
  const format = /(.+), (\d{2}):(\d{2}):(\d{2})/;
  const matches = date.toLocaleTimeString('en-US', {
    hour12: false,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  }).match(format);

  return `${matches[2]}:${matches[3]} - ${matches[1]}`;
};

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
