import React from 'react'
import Bid from './Bid'

const BidsList = ({bids}) =>
<div id="bids">
  <h3 className="heading-label"> Bid History: </h3>
  <ul>
    {bids.map((bid, i) => {
      return(<Bid key={i} bid={bid} />)
    })}
  </ul>
</div>




export default BidsList
