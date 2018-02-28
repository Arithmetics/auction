import React from 'react'
import TeamCard from './TeamCard'

export default class TeamArea extends React.Component {
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
      <div className="box">

        {this.props.users.map(function(user) { return <TeamCard
            key={user.id}
            user={user}
            auctioneer={auctioneer}
            year={year}
            draftId={draftId}/> })}

      </div>
    )
  }
}
