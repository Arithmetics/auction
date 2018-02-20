$(document).on('turbolinks:load', function(){
    $(".alert").hide().delay(800).fadeIn(800).delay(4000).slideUp(800, function(){
          $(".alert").alert('close');
      });
    });
