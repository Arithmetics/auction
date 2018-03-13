import React from 'react'

export default class BestAvailable extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      filter: null
    }
    this.filterResults = this.filterResults.bind(this)
  }

  filterResults(e){
    e.preventDefault()
    if(e.target.textContent == "All") {
      this.setState({filter: null})
    } else {
      this.setState({filter: e.target.textContent})
    }
  }

  render(){
    let bestAvailable;
    if(this.state.filter){
      bestAvailable = this.props.bestAvailable.filter(
        (player) => player.position == this.state.filter
      )
    } else {
      bestAvailable = this.props.bestAvailable
    }

    return(
      <div>
        <h3 className="heading-label" id="best-av-label"> Best Available </h3>
        <div className="button-box">
          <button className="best-filter" onClick={this.filterResults}>
            All
          </button>
          <button className="best-filter" onClick={this.filterResults}>
            QB
          </button>
          <button className="best-filter" onClick={this.filterResults}>
            RB
          </button>
          <button className="best-filter"onClick={this.filterResults}>
            WR
          </button>
          <button className="best-filter" onClick={this.filterResults}>
            TE
          </button>
          <button className="best-filter" onClick={this.filterResults}>
            DEF
          </button>
          <button className="best-filter" onClick={this.filterResults}>
            K
          </button>
        </div>
        <ol className="under-list best-bid-list">
          {bestAvailable.map((player, i) => {
            return(<li className="best-item" key={i}>{player.firstName} {player.lastName}, {player.position}</li>)
          })}
        </ol>
      </div>
    )
  }
}
