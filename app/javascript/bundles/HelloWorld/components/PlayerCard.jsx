import React from 'react'

export default class PlayerCard extends React.Component {
  constructor(props){
    super(props)
    this.state = {
    }
  }

  render(){
    return(
      <div id="player_for_sale" className="player-card">
        <div className='center-pic'>
          <img
            src={"http://static.nfl.com/static/content/public/static/img/fantasy/transparent/200x200/" + this.props.nominatedPlayer.esbid + ".png"} className="player-pic" />
        </div>
        <div className='player-info'>
          <h3 className="card-info">
            {this.props.nominatedPlayer.player_name},  {this.props.nominatedPlayer.position}
          </h3>
          <div className="price">
            <div className="price-circle">
              <h4 className="card-info">Current Bid:
              <span id="current-bid"> ${this.props.bids[0].amount}</span></h4>
            </div>
          </div>
          <h4 className="card-info"> Leading Bidder: <span id="leading-bidder">{this.props.bids[0].user.name}</span></h4>
        </div>
      </div>
    )
  }


}
