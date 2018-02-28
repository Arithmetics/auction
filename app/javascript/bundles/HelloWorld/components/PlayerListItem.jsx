import React from 'react'
import UndraftPlayerButton from './UndraftPlayerButton'

export default class PlayerListItem extends React.Component {
  constructor(props) {
    super(props)
    this.state = {

    }
  }

  render(){
    let button = null
    let auctioneer = this.props.auctioneer
    let draftId = this.props.draftId
    if (auctioneer) {
      button =
        <UndraftPlayerButton
          playerId={this.props.player.id}
          year={this.props.year}
          draftId={draftId}
          />
    } else {
      console.log("not an auctioneer huh")
    }
    return(
      <li>
        {this.props.player.player_name}, {this.props.player.position} -
        ${this.props.amount} {button}
      </li>

    )
  }
}
