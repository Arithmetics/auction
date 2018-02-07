class DraftsController < ApplicationController

  def index
    @drafts = Draft.all
  end


  def show
    @draft = Draft.find(params[:id])
    @nominated_player = @draft.nominated_player
    @players = Player.all
    @users = User.all
    @bids = @draft.bids.where(player: @nominated_player).order(:amount).reverse

    @bid = current_user.bids.build(
      draft: @draft,
      player: @nominated_player,
      winning: false);

  end


  def nominate
    @draft = Draft.find(params[:id])
    if @draft.update_attributes(draft_params)
      starting_bid = @draft.bids.build(player_id: @draft.nominated_player_id, user: current_user, amount: 1)
      starting_bid.save
      redirect_to request.referer
    else
      flash[:alert] = "error"
      redirect_to request.referer
    end
  end

  def unnominate
    @draft = Draft.find(params[:id])
    player = Player.find(@draft.nominated_player_id)
    bids = player.bids.select { |bid| bid.draft.year == @draft.year }
    if @draft.update_attribute(:nominated_player_id, nil)
      bids.each { |bid| bid.destroy }
      redirect_to request.referer
    else
      flash[:alert] = "error"
      redirect_to request.referer
    end
  end

  def undo_drafting
    player = Player.find(params[:draft][:player_id])
    bids = player.bids.select {|bid| bid.draft.year == params[:draft][:year].to_i}
    bids.each do |bid|
      bid.destroy
      puts bid.amount
    end
    redirect_to request.referer
  end


  private ####################

  def draft_params
    params.require(:draft).permit(:year, :format, :nominated_player_id)
  end

end
