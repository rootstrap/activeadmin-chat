export default (date) => {
  const format = /(.+), (\d{2}):(\d{2}):(\d{2})/;
  const matches = date.toLocaleTimeString('en-US', {
    hour12: false,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  }).match(format);

  return `${matches[2]}:${matches[3]} - ${matches[1]}`;
};
