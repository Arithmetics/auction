import React from 'react'
import {ResponsiveContainer, Label, LineChart, CartesianGrid, XAxis, YAxis, Tooltip, Legend, Line } from 'recharts'


export default class LineGraph extends React.Component {
  constructor(props) {
    super(props)
    this.state = {

    }
  }

  toggleMin(e){
    e.preventDefault();

  }

  render(){
    let data = this.props.data
    let title = this.props.title
    let color = this.props.color
    let yData = this.props.yData
    let show = this.state.show
    let id = this.props.id
      return(
        <div className="graph" id={id}>
          <i className="ion-ios-minus-outline minimize" onClick={this.toggleMin.bind(this)}></i>
          <h4 className="graphtitle">{title}</h4>
          <ResponsiveContainer height={295} width="95%">
          <LineChart data={data}
            margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
            <Label value="title" offset={0} position="insideBottom" />

            <XAxis dataKey={"year"} height={25}/>
            <YAxis dataKey={yData} width={25}/>
            <Tooltip content={<CustomTooltip/>}/>
            <Line type="monotone" dataKey={yData} stroke={color} strokeWidth= "3" />
          </LineChart>
          </ResponsiveContainer>
        </div>
      )
  }
}


class CustomTooltip extends React.Component {
  constructor(props) {
    super(props)
    this.state = {

    }
  }

  render() {
    const { active } = this.props;
    let draftedTag;
    let valueTag;
    if (active) {
      const { payload, label } = this.props;
      if(payload && payload.length > 0 && payload[0].payload.user){
        draftedTag = <p className="intro">{`Drafted by: ${payload[0].payload.user}`}</p>
        valueTag = <p className="label">{`${label} : ${payload[0].value}`}</p>
      }
      return (
        <div className="custom-tooltip">
          {valueTag}
          {draftedTag}
        </div>
      );
    }
    return null;
  }
};
