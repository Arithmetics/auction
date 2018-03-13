import React from 'react'
import PlayerListItem from './PlayerListItem'


export default class TeamCard extends React.Component {
  constructor(props) {
    super(props)
    this.state = {

    }
  }

  render(){
    let auctioneer = this.props.auctioneer
    let year = this.props.year
    let draftId = this.props.draftId
    return(
      <div className="your-team">
        <p className="user-header current-user">{this.props.user.name} -
        <span className="user-money" id="<%= 'user-money-' + current_user.id.to_s %>">${this.props.user.money_remaining}</span> </p>
        <ol className="under-list">
          {this.props.user.team.map(function(aquisition) { return <PlayerListItem key={aquisition.player.id} amount={aquisition.amount} player={aquisition.player} auctioneer={auctioneer} year={year} draftId={draftId}/> })}
        </ol>
      </div>
    )
  }
}
