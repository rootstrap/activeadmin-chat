export default () => {
  const oldestDate = document.querySelector('.active-admin-chat__conversation-history').children[0].dataset.time;
  return new Date(oldestDate);
};
