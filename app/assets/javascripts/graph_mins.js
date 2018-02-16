$(document).ready(function(){
  const ids=[1,2,3,4]
  let graphMinButton;
  let graphMaxButton;
  ids.forEach(function(id){
    graphMinButton = document.getElementById(`minimizegraph${id}`);
    graphMinButton.addEventListener('click',function(e){
      document.getElementById(`graph${id}`).style.display = "none";
      document.getElementById(`maxgraph${id}`).style.display = "inline";
    })
    graphMaxButton = document.getElementById(`maxgraph${id}`);
    graphMaxButton.addEventListener('click',function(e){
      console.log('click')
      document.getElementById(`graph${id}`).style.display = "inline-block";
      document.getElementById(`maxgraph${id}`).style.display = "none";
    })
  })
})


// graph1_minimize.addEventListener('click', function(e){
//   const graph_div = document.getElementById('graph1');
//   graph_div.style.display = 'none';
// })
