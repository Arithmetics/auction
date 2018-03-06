class DraftsController < ApplicationController
  before_action :user_is_auctioneer, only: [:create, :new, :edit, :update, :undo_drafting, :unnominate]
  before_action :draft_is_open, only: [:show]
  before_action :users_turn_to_nominate, only: [:nominate]

  def index
    @drafts = Draft.all
  end

  def new
    @draft = Draft.new
  end

  def edit
    @draft = Draft.find(params[:id])
  end

  def update
    @draft = Draft.find(params[:id])
    if @draft.update_attributes(draft_params)
      flash[:success] = "Draft edited"
      redirect_to drafts_path
    else
      flash.now[:danger] = "Issue"
      render 'edit'
    end
  end

  def create
    @draft = Draft.new(draft_params)
    if @draft.save
      flash[:success] = "Draft created"
      redirect_to drafts_path
    else
      redirect_to request_referer
    end
  end

  def show
    @users = User.all.where(auctioneer: false)
    @current_user = current_user
    @unsold_players = Player.unsold(@draft.year)
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
        nomination: render(partial: 'drafts/nominate', locals: { draft: @draft, nominated_player: @nominated_player })
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
        unnomination: render(partial: 'drafts/unnominate')
    else
      flash[:alert] = "error"
      redirect_to request.referer
    end
  end

  def undo_drafting
    player = Player.find(params[:draft][:player_id])
    bids = player.bids.select {|bid| bid.draft.year == params[:draft][:year].to_i}
    user = bids.last.user
    year = params[:draft][:year]
    bids.each do |bid|
      bid.destroy
    end
    @users = User.all.where(auctioneer: false)
    @draft = Draft.find(params[:id])
    ActionCable.server.broadcast "draft_#{params[:draft][:draft_id]}",
      undo_drafting: render(partial: 'undo_drafting.json', locals: { player: player, money_remaining: user.money_remaining(year) })
  end


  private ####################

  def draft_params
    params.require(:draft).permit(:year, :format, :nominated_player_id, :open)
  end

  def user_is_auctioneer
    redirect_to (request.referer || root_url) unless current_user.auctioneer?
  end

  def users_turn_to_nominate
    @draft = Draft.find(params[:id])
    redirect_to request.referer || root_url unless current_user.auctioneer? || current_user == @draft.nominating_user
  end

  def draft_is_open
    @draft = Draft.find(params[:id])
    if !@draft.open
      flash[:danger] = "Draft is closed!"
      redirect_to root_path
    end
  end

end
