import React from 'react'

export default class PlayerCard extends React.Component {
  constructor(props){
    super(props)
    this.state = {
    }
  }

  render(){
    let bidAmount;
    let bidUser;
    if(this.props.bids[0] && this.props.bids[0].amount != null){
      bidAmount = this.props.bids[0].amount
      bidUser = this.props.bids[0].user.name
    }
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
              <span id="current-bid"> ${bidAmount}</span></h4>
            </div>
          </div>
          <h4 className="card-info"> Leading Bidder: <span id="leading-bidder">{bidUser}</span></h4>
        </div>
      </div>
    )
  }


}
