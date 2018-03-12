import PropTypes from 'prop-types';
import React from 'react';
import update from 'immutability-helper'
import BidsList from './BidsList'
import BidForm from './BidForm'
import PlayerCard from './PlayerCard'
import TeamArea from './TeamArea'
import NominationSelector from './NominationSelector'
import LineGraph from './LineGraph'
import GraphButton from './GraphButton'
import BestAvailable from './BestAvailable'

export default class Draft extends React.Component {
  constructor(props) {
    super(props);

    this.handleGraphMax = this.handleGraphMax.bind(this)
    this.handleGraphMin = this.handleGraphMin.bind(this)

    let draft = JSON.parse(this.props.draft)
    console.log(draft)
    this.state = {
      auctioneer: draft.auctioneer,
      bids: draft.bids,
      draftId: draft.id,
      year: draft.year,
      nominatedPlayer: draft.nominated_player,
      users: draft.users,
      unsold_players: draft.unsold_players,
      nominatingUser: draft.nominating_user,
      currentUser: draft.current_user,
      displayGraphs: [false, false, false, false],
      bestAvailable: draft.best_available
    };
  }

  updateBids(bid){
    const bids = update(this.state.bids, {$unshift: [bid]})
    this.setState({bids: bids})
  }

  removeFromTeam(data){
    let userIndex
    let teamIndex
    this.state.users.forEach(function(user, indexX){
      user.team.forEach(function(entry, indexY){
        if (entry.player.id == data.player.id) {
          userIndex = indexX
          teamIndex = indexY
        }
      })
    })
    const new_users = update(this.state.users,{[userIndex]: {team: {$splice: [[teamIndex, 1]] }}})
    this.setState({users: new_users})
    const a_users = update(this.state.users,{[userIndex]: {money_remaining: {$set: data.money_remaining}}})
    this.setState({users: a_users})
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
    const newUsers = update(this.state.users,{[userIndex]: {money_remaining: {$set: data.money_remaining}}})
    this.setState({users: newUsers})

    const anotherUpdate = update(this.state.users, {[userIndex]: {team: {$push: [data.team[data.team.length-1]]}}})
    this.setState({users: anotherUpdate})

    const newNomUser = update(this.state.nominatingUser, {
      $set: data.nominating_user })
    this.setState({nominatingUser: newNomUser})

    // need to remove player from best available
    let bestIndex;
    this.state.bestAvailable.forEach(function(entry, i){
      if (entry.esbid == data.team[data.team.length -1].player.esbid) {
        bestIndex = i
      }
    })
    const newBestAvailable = update(this.state.bestAvailable,{$splice: [[bestIndex, 1]] })
    this.setState({bestAvailable: newBestAvailable});


    // need to remove player from drop down list
    let unsoldIndex;
    this.state.unsold_players.forEach(function(entry, i){
      if (entry.esbid == data.team[data.team.length -1].player.esbid) {
        unsoldIndex = i
      }
    })
    const new_unsoldPlayers = update(this.state.unsold_players,{$splice: [[unsoldIndex, 1]] })
    this.setState({unsold_players: new_unsoldPlayers});
  }

  unnominate(){
    const noNomPlayerState = update(this.state.nominatedPlayer,
      { $set: null })
    this.setState({nominatedPlayer: noNomPlayerState})
  }


  handleGraphMax(i){
    const newDisplay = this.state.displayGraphs;
    newDisplay[i-1] = true
    this.setState({displayGraphs: newDisplay})
  }

  handleGraphMin(i){
    const newDisplay = this.state.displayGraphs;
    newDisplay[i-1] = false
    this.setState({displayGraphs: newDisplay})
  }


  nominate(data){
    const nomPlayerState = update(this.state.nominatedPlayer,
      { $set: data.nominated_player })
    this.setState({nominatedPlayer: nomPlayerState})

    const bidState = update(this.state.bids, {
      $set: data.bids })
    this.setState({bids: bidState})
  }

  componentDidMount(){
    //websockets Action Cable Subs
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
        // player is deleted from team
        if (data.undo_drafting != null) {
          this.removeFromTeam(JSON.parse(data.undo_drafting));
        }
        //player is sold
        if (data.sold_player != null) {
          this.sellPlayer(JSON.parse(data.sold_player));
        }
        //player is unnominated from draft
        if (data.unnomination != null) {
          this.unnominate();
        }
        //player is nominated for bidding
        if (data.nomination != null) {
          this.nominate(JSON.parse(data.nomination));
        }
      }.bind(this)
    });
    //sreen query for initial state
    let width = $(window).width()
    if (width > 1560){
      this.setState({displayGraphs: [true, true, true, true]})
    } else if (width > 1265) {
      this.setState({displayGraphs: [true, true, true, false]})
    } else if(width > 970) {
      this.setState({displayGraphs: [true, true, false, false]})
    } else if(width > 680) {
      this.setState({displayGraphs: [true, false, false, false]})
    } else {

    }
  }

  render(){

    if (this.state.nominatedPlayer){
      let graph1;
      let graph2;
      let graph3;
      let graph4;
      let graphButton1;
      let graphButton2;
      let graphButton3;
      let graphButton4;
      if(this.state.displayGraphs[0]){
        graph1 = (<LineGraph
          title={"Auction $ Spent"}
          data={this.state.nominatedPlayer.master_graphs_hash.sales}
          color="#00c87c"
          yData="amount"
          id="graph1"
          graphid="1"
          onClick={this.handleGraphMin}
        />)
      } else {
        graphButton1 = (
          <GraphButton
            id="maxgraph1" graphid="1"
            onClick={this.handleGraphMax}
          />
        )
      }
      if(this.state.displayGraphs[1]){
        graph2 = (<LineGraph
          title={"Total Pts Scored"}
          data={this.state.nominatedPlayer.master_graphs_hash.season_pts}
          color="#8884d8"
          yData="season_fantasy_points"
          id="graph2"
          graphid="2"
          onClick={this.handleGraphMin}
        />)
      } else {
        graphButton2 = (
          <GraphButton id="maxgraph2" graphid="2" onClick={this.handleGraphMax}/>
        )
      }
      if(this.state.displayGraphs[2]){
        graph3 = (<LineGraph
          title={"Pts / Game"}
          data={this.state.nominatedPlayer.master_graphs_hash.pts_per_game}
          color="#ff6560"
          yData="pts_per_game"
          id="graph3"
          graphid="3"
          onClick={this.handleGraphMin}
        />)
      } else {
        graphButton3 = (
          <GraphButton id="maxgraph3" graphid="3" onClick={this.handleGraphMax}/>
        )
      }
      if(this.state.displayGraphs[3]){
        graph4 = (<LineGraph
          title={"Games Played"}
          data={this.state.nominatedPlayer.master_graphs_hash.games_played}
          color="#ffcb5e"
          yData="games_played"
          id="graph4"
          graphid="4"
          onClick={this.handleGraphMin}
        />)
      } else {
        graphButton4 = (
          <GraphButton id="maxgraph4" graphid="4" onClick={this.handleGraphMax}/>

        )
      }
      return (
        <div>
          <div className="box">
            <PlayerCard
              nominatedPlayer={this.state.nominatedPlayer}
              bids={this.state.bids}
            />
            {graph1}
            {graph2}
            {graph3}
            {graph4}
            <div id="graph-shortcuts">
              {graphButton1}
              {graphButton2}
              {graphButton3}
              {graphButton4}
            </div>
          </div>
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
          <div className="best-available box">
            <BestAvailable bestAvailable={this.state.bestAvailable}/>
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
          <NominationSelector
            auctioneer={this.state.auctioneer}
            year={this.state.year}
            draftId={this.state.draftId}
            unsoldPlayers={this.state.unsold_players}
            nominatingUser={this.state.nominatingUser}
            currentUser={this.state.currentUser}
            />
            <div className="best-available box">
              <BestAvailable bestAvailable={this.state.bestAvailable}/>
            </div>
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
