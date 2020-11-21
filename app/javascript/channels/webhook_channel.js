import consumer from './consumer';

/**
 * Dateオブジェクトを YYYY-mm-dd HH:MM:SS にフォーマットする
 *
 * @param {Date} date
 */
function formatDate(date) {
  return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
}

/**
 * Stripe Event の created を YYYY-mm-dd HH:MM:SS にフォーマットする
 *
 * @param {nuber} created エポックからのsecond
 */
function formatEventCreated(created) {
  const date = new Date(created * 1000);
  return formatDate(date);
}

// Event出力要素
const webhookChannel = document.getElementById("webhookChannel");
const autoClose = document.getElementById('auto-close');

/**
 * メッセージを出力要素に追加する
 *
 * @param {string}} message 文字列メッセージ
 */
function appendMessage(message) {
  const element = document.createElement('div');
  element.classList.add('message');
  element.innerHTML = `[${formatDate(new Date())}] ${message}`;
  webhookChannel.appendChild(element);
}

/**
 * Stripe Event を出力要素に追加する
 *
 * @param {object} event Stripe Event
 */
function appendEvent(event) {
  const element = document.createElement('div');
  element.classList.add('stripe-event');

  const detailsElm = document.createElement('details');
  detailsElm.setAttribute('open', true);
  const summaryElm = document.createElement('summary');
  const created = formatEventCreated(event.created);
  summaryElm.innerHTML = `[${created}] <strong>${event.type}</strong> - "${event.data.object.id}"`;
  detailsElm.appendChild(summaryElm);
  const preElm = document.createElement('pre');
  const codeElm = document.createElement('code');
  codeElm.innerText = JSON.stringify(event, null, 4);
  hljs.highlightBlock(codeElm); // code highlight by highlight.js

  if (autoClose.checked) closeAllDetails();

  preElm.appendChild(codeElm);
  detailsElm.appendChild(preElm);
  element.appendChild(detailsElm);
  webhookChannel.appendChild(element);
}

// Action Cable の処理
consumer.subscriptions.create("WebhookChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    const connectedMessage = 'Connect webhook channel';
    console.log(connectedMessage);
    appendMessage(connectedMessage);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Disconnect webhook channel');
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if (typeof data === 'string') {
      appendMessage(data);
    } else if (data.event) {
      appendEvent(data.event);
    }
  }
});

/**
 * 開いたコードブロックをすべて閉じる
 */
function closeAllDetails() {
  const details = document.querySelectorAll('div.stripe-event details[open]');
  details.forEach((d) => {
    d.removeAttribute('open');
  })
}

document.getElementById('close-all-details').addEventListener('click', closeAllDetails);
