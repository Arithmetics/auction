class DraftChannel < ApplicationCable::Channel
  def subscribed
    draft = Draft.find(params[:id])
    stream_for draft 
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
