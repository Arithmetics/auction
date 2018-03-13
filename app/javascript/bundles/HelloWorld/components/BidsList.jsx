import React from 'react'
import Bid from './Bid'
import { CSSTransitionGroup } from 'react-transition-group'

const BidsList = ({bids}) =>
<div id="bids">
  <h3 className="heading-label"> Bid History: </h3>
  <ul className="under-list" id="bid-under-list">
    <CSSTransitionGroup
    transitionName="example"
    transitionAppear={true}
    transitionEnterTimeout={1500}
    transitionLeaveTimeout={1500}
    transitionAppearTimeout={1500}>
    {bids.map((bid, i) => {
      return(<Bid key={i} bid={bid} />)
    })}
  </CSSTransitionGroup>
  </ul>
</div>




export default BidsList
