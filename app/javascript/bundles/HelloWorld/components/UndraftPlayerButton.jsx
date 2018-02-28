import React from 'react'

export default class UndraftPlayerButton extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      year: this.props.year,
      playerId: this.props.playerId,
      draftId: this.props.draftId
    }
  }

  handleClick = (e) => {
    e.preventDefault()
    $.ajax({
      url: `/drafts/${this.state.draftId}/undo_drafting`,
      type: 'PATCH',
      data: {draft:
        { player_id: this.state.playerId,
          year: this.state.year,
          draft_id: this.state.draftId
        } }
    })
      .done(response => {
        console.log(response)
      } )
  }

  render(){
    return(
      <button onClick={this.handleClick} className="remove">Remove</button>
    )
  }
}
