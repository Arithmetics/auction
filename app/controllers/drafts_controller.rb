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
    puts "XXXXXXXXXXXXXXXXX"
    @draft = Draft.find(params[:id])
    puts @draft
    player = Player.find(@draft.nominated_player_id)
    if @draft.update_attribute(:nominated_player_id, nil)
      puts "ZZZZZZZZZZ"
      redirect_to request.referer
    else
      flash[:alert] = "error"
      redirect_to request.referer
    end
  end


  private ####################

  def draft_params
    params.require(:draft).permit(:year, :format, :nominated_player_id)
  end

end
