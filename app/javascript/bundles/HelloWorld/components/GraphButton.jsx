import React from 'react'

export default class GraphButton extends React.Component {
  constructor(props) {
    super(props)
    this.state = {

    }
  }

  render(){
    let id = this.props.id
    return(
      <i className="icon ion-arrow-graph-up-right min-graph" id={id}></i>
    )
  }
}
