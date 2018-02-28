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

  sellPlayer(data){
    const noNomPlayerState = update(this.state.nominatedPlayer,
      { $set: null })
    this.setState({nominatedPlayer: noNomPlayerState})

    let userIndex
    this.state.users.forEach(function(user, indexX){
      if (user.id == data.id) {
        userIndex = indexX
      }
    })
    const new_users = update(this.state.users,{[userIndex]: {money_remaining: {$set: data.money_remaining}}})
    this.setState({users: new_users})

    const a_users = update(this.state.users, {[userIndex]: {team: {$push: [data.team[data.team.length-1]]}}})
    this.setState({users: a_users})
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

        if (data.sold_player != null) {
          console.log("this part runs")
          this.sellPlayer(JSON.parse(data.sold_player))
        }


      }.bind(this)
    });
  }


  render() {
    if (this.state.nominatedPlayer){
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
              auctioneer={this.state.auctioneer}
              bids={this.state.bids}
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
    } else {
      return (
        <div>
        <h3>No nominated player</h3>
        <TeamArea
          users={this.state.users}
          auctioneer={this.state.auctioneer}
          year={this.state.year}
          draftId={this.state.draftId}
        />
        </div>
      )
    }

  }
}
