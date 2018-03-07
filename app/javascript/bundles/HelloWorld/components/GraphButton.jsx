import React from 'react'

export default class GraphButton extends React.Component {
  constructor(props) {
    super(props)

    this.doParentGraphToggle = this.doParentGraphToggle.bind(this);
  }

  doParentGraphToggle(){
    let index = parseInt(this.props.graphid)
    this.props.onClick(index)
  }


  render(){
    let id = this.props.id
    return(
      <i
        className="icon ion-arrow-graph-up-right min-graph" id={id}
        onClick={ this.doParentGraphToggle }
        >
      </i>
    )
  }
}
