export default (channelSubscription) => {
  document.querySelector('#send-message').addEventListener('keypress', (event) => {
    if (event.which === 13 && event.target.value) {
      channelSubscription.sendMessage(event.target.value);
      event.target.value = '';
    }
  });
};
