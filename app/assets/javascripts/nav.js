$(document).on('turbolinks:load', function(){
  const x = document.getElementById("myTopnav");
  x.addEventListener('click', function(){
    console.log('fusdf')
    if (x.className === "topnav") {
        x.className += " responsive";
    } else {
        x.className = "topnav";
    }
  })
})
