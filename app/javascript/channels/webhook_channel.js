import consumer from "./consumer"

consumer.subscriptions.create("WebhookChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connect webhook channel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('disconnect webhook channel');
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(`recieve "${JSON.stringify(data)}"`);
  }
});
