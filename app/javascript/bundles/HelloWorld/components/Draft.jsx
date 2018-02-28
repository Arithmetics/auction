import PropTypes from 'prop-types';
import React from 'react';
import update from 'immutability-helper'
import BidsList from './BidsList'
import BidForm from './BidForm'
import PlayerCard from './PlayerCard'
import TeamArea from './TeamArea'

export default class Draft extends React.Component {
  constructor(props) {
    super(props);
    let draft = JSON.parse(this.props.draft)
    console.log(draft)
    this.state = {
      auctioneer: draft.auctioneer,
      bids: draft.bids,
      draftId: draft.id,
      year: draft.year,
      nominatedPlayer: draft.nominated_player,
      users: draft.users
    };
  }

  updateBids(bid){
    const bids = update(this.state.bids, {$unshift: [bid]})
    this.setState({bids: bids})
  }

  removeFromTeam(undone_player){
    let userIndex
    let teamIndex
    this.state.users.forEach(function(user, indexX){
      user.team.forEach(function(entry, indexY){
        if (entry.player.id == undone_player.id) {
          userIndex = indexX
          teamIndex = indexY
        }
      })
    })
    const new_users = update(this.state.users,{[userIndex]: {team: {$splice: [[teamIndex, 1]] }}})
    this.setState({users: new_users})
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

        if (data.undo_drafting != null) {
          this.removeFromTeam(JSON.parse(data.undo_drafting));
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
            draftId={this.state.draftId}
          />
          <BidsList
            bids={this.state.bids}
          />
        </div>
        <TeamArea
          users={this.state.users}
          auctioneer={this.state.auctioneer}
          year={this.state.year}
          draftId={this.state.draftId}
        />
      </div>
    );
  }
}
