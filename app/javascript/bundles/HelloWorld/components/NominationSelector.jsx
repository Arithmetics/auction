import React from 'react'
import NominationForm from './NominationForm'


export default class NominationSelector extends React.Component {
  constructor(props) {
    super(props)
    this.state = {

    }
  }


  render(){
    let unsoldPlayers = this.state.unsoldPlayers

    let nominationForm;
    if(this.props.nominatingUser.id == this.props.currentUser.id || this.props.auctioneer) {
      nominationForm = (<NominationForm
        draftId={this.props.draftId}
        unsoldPlayers={this.props.unsoldPlayers}
      />)
    }

    let message;
    if(this.props.nominatingUser.id == this.props.currentUser.id) {
      message = "It is your turn to nominate!"
    } else {
      message = `Waiting for nomination from:  ${this.props.nominatingUser.name}`
    }

    return(
      <div>
        <h3 className="heading-label">
          {message}
        </h3>
          {nominationForm}
      </div>
    )
  }
}
