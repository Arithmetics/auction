App.draft = App.cable.subscriptions.create("DraftChannel", {
  connected() {},
    // Called when the subscription is ready for use on the server

  disconnected() {},
    // Called when the subscription has been terminated by the server

  received(data) {
    if (data.bid != null) {
      $('#bid-list').prepend(data.bid);
      $('#current-bid').html( "Current Bid: " + data.amount);
      $('#leading-bidder').html( "Leading Bidder: " + data.leading);
    }
  }
}
);
