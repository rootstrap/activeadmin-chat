import getOldestDate from '../getOldestDate';
import messageToHtml from '../messageToHtml';

let gettingNewMessages = false;

export default () => {
  const conversationHistory = document.querySelector('.active-admin-chat__conversation-history');
  conversationHistory.addEventListener('scroll', () => {
    if (conversationHistory.scrollTop === 0 && !gettingNewMessages) {
      gettingNewMessages = true;
      const urlParams = `?created_at=${getOldestDate().toString()}`;
      fetch(`${window.location.href.split('?')[0]}.json${urlParams}`, {
        headers: { 'Content-Type': 'application/json' }
      }).then(
        response => response.json()
      ).then(data => {
        const oldHeight = conversationHistory.scrollHeight;
        conversationHistory.insertAdjacentHTML('afterbegin', data.messages.map(message => messageToHtml(message)).join(''));
        conversationHistory.scrollTop = conversationHistory.scrollHeight - oldHeight;
        gettingNewMessages = false;
      });
    }
  });
};
