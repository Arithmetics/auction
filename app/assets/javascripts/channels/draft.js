$(document).on('turbolinks:load'), function(){
  App.draft = App.cable.subscriptions.create({
    channel: "DraftChannel",
    id: $('#zone').attr('data-chatroom-id')
    },
    {
      received: function(data){
        $('#zone').html(data.message);
      }
    }
  })
}
