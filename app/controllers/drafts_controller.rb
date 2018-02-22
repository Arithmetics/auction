class DraftsController < ApplicationController
  before_action :user_is_auctioneer, only: [:undo_drafting, :unnominate]
  before_action :draft_is_open, only: [:show]
  before_action :users_turn_to_nominate, only: [:nominate]

  def index
    @drafts = Draft.all
  end


  def show
    @top_remaining = Player.top_remaining(@draft.year)[0..30]
    @nominated_player = @draft.nominated_player
    @players = Player.all
    @users = User.all.where(auctioneer: false)
    @bids = @draft.bids.where(player: @nominated_player).order(:amount).reverse

    @bid = current_user.bids.build(
      draft: @draft,
      player: @nominated_player,
      winning: false);

  end


  def nominate

    @top_remaining = Player.top_remaining(@draft.year)[0..30]
    if @draft.update_attributes(draft_params)
      starting_bid = @draft.bids.build(player_id: @draft.nominated_player_id, user: current_user, amount: 1)
      starting_bid.save
      @nominated_player = @draft.nominated_player
      @bids = @draft.bids.where(player: @nominated_player).order(:amount).reverse
      @bid = current_user.bids.build(
        draft: @draft,
        player: @nominated_player,
        winning: false);

      ActionCable.server.broadcast "draft_#{@draft.id}",
        player_for_sale: render(partial: 'drafts/bidding_panel', locals: {
          nominated_player: @nominated_player,
          bids: @bids,
          draft: @draft,
          bid: @bid,
          top_remaining: @top_remaining
           })
    else
      flash[:alert] = "error"
      redirect_to request.referer
    end
  end

  def unnominate
    @draft = Draft.find(params[:id])
    @top_remaining = Player.top_remaining(@draft.year)[0..30]
    player = Player.find(@draft.nominated_player_id)
    bids = player.bids.select { |bid| bid.draft.year == @draft.year }
    if @draft.update_attribute(:nominated_player_id, nil)
      bids.each { |bid| bid.destroy }
      ActionCable.server.broadcast "draft_#{@draft.id}",
        nomination: render(partial: 'drafts/nomination', locals: { draft: @draft })
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
    end

    ActionCable.server.broadcast "draft_#{@draft.id}",
      undrafted: player.player_name, team_id: bids.last.user_id
  end


  private ####################

  def draft_params
    params.require(:draft).permit(:year, :format, :nominated_player_id)
  end

  def user_is_auctioneer
    redirect_to request.referer unless current_user.auctioneer?
  end

  def users_turn_to_nominate
    @draft = Draft.find(params[:id])
    redirect_to request.referer unless current_user.auctioneer? || current_user == @draft.nominating_user
  end

  def draft_is_open
    @draft = Draft.find(params[:id])
    if !@draft.open
      flash[:danger] = "Draft is closed!"
      redirect_to root_path
    end
  end

end
