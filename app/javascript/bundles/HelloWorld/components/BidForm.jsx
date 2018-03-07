import React from 'react'

export default class BidForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      amount: 1,
      year: this.props.year,
      nominatedPlayer: this.props.nominatedPlayer,
      draftId: this.props.draftId
    }
  }

  handleBidChange = (e) => { this.setState({amount: this.amount.value})}

  handleSubmit = (e) => {
    e.preventDefault()
    $.post(
      `/bids`,
      { bid:
        { amount: this.state.amount,
          player_id: this.state.nominatedPlayer.id,
          draft_id: this.state.draftId,
          winning: false
        }
      })
      .done(response => {
        console.log(response)
      } )
  }

  handleUnnominateSubmit = (e) => {
    e.preventDefault()
    console.log("yo")
    $.ajax({
      url: `/drafts/${this.state.draftId}/unnominate`,
      type: 'PATCH'
    })
      .done(response => {
        console.log(response)
      } )
  }

  handleSellClick = (e) => {
    e.preventDefault()
    $.ajax({
      url: `/bids/${this.props.bids[0].id}`,
      type: 'PATCH',
      data: {bid:
        { winning: true
        } }
    })
      .done(response => {
        console.log(response)
      } )
  }

  render(){
    if(this.props.auctioneer) {
      return (
        <div className="auctioneer">
          <div id="sell_player">
            <button onClick={this.handleSellClick} className="sell-button">Sell Player</button>
          </div>
          <div id="unnominate">
            <form onSubmit={this.handleUnnominateSubmit}>
              <input type="submit" value="Unnominate" name="commit" className="cancel-auction" />
            </form>
          </div>
        </div>
      )
    } else {
      return (
        <div id="bidding-form" >
          <form onSubmit={this.handleSubmit}>
            <span className="money">
              $
            </span>
            <span className="num-field">
              <input id="bid_amount" type="number" name="amount" value={this.state.amount} onChange={this.handleBidChange} ref={input => this.amount = input } />
            </span>
            <input type="submit" value="Submit Bid" name="commit" className="bid-button" />
          </form>
        </div>
      )
    }
  }
}
