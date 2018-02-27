import PropTypes from 'prop-types';
import React from 'react';
import update from 'immutability-helper'
import BidsList from './BidsList'
import BidForm from './BidForm'
import PlayerCard from './PlayerCard'

export default class Draft extends React.Component {
  constructor(props) {
    super(props);
    let draft = JSON.parse(this.props.draft)
    console.log(draft)
    this.state = {
      bids: draft.bids,
      draftId: draft.id,
      year: draft.year,
      nominatedPlayer: draft.nominated_player
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
          this.updateBids(JSON.parse(data.bid));
        }
      }.bind(this)
    });
  }


  render() {
    return (
      <div>
        <PlayerCard
          nominatedPlayer={this.state.nominatedPlayer}
          bids={this.state.bids}
          />
        <div className="bid-box">
          <BidForm
            draftId={this.state.draftId}
            year={this.state.year}
            nominatedPlayer={this.state.nominatedPlayer}
            draftId={this.state.draftId}/>
          <BidsList
            bids={this.state.bids}
            />
        </div>
      </div>
    );
  }
}
