import PropTypes from 'prop-types';
import React from 'react';
import update from 'immutability-helper'
import BidsList from './BidsList'

export default class Draft extends React.Component {
  constructor(props) {
    super(props);
    let draft = JSON.parse(this.props.draft)
    console.log(draft)
    this.state = {
      bids: draft.bids,
      draftId: draft.id
    };
  }

  updateBids(bid){
    console.log(bid)
    const bids = update(this.state.bids, {$unshift: [bid]})
    this.setState({bids: bids})
    console.log(this.state)
  }

  componentDidMount(){
    App.draft = App.cable.subscriptions.create({
        channel: "DraftChannel",
        id: this.state.draftId
    },
    {
      received: function(data) {
        // bid is sumbitted
        if (data.bid != null) {
          console.log("new bid received")
          this.updateBids(JSON.parse(data.bid));
        }

      }.bind(this)
    });
  }

  updateName = (name) => {
    this.setState({ name });
  };

  render() {
    return (
      <div>
        <div className="bid-box">
          <BidsList bids={this.state.bids} />
        </div>
      </div>
    );
  }
}
