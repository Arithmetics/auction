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

  handleChange = (e) => { this.setState({amount: this.amount.value})}

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

  render(){
    return (
      <div id="bidding-form" >
        <form onSubmit={this.handleSubmit}>
          <span className="money">
            $
          </span>
          <span className="num-field">
            <input type="number" name="amount" value={this.state.amount} onChange={this.handleChange} ref={input => this.amount = input } />
          </span>
          <input type="submit" value="Submit Bid" name="commit" className="bid-button" />
        </form>
      </div>
    )
  }
}
