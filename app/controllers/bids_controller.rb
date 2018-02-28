class BidsController < ApplicationController
  before_action :not_winning, :check_if_enough_money, :check_if_top_bid, only: :create
  before_action :user_is_auctioneer, only: [:destroy, :update]
  before_action :auctioneer_cant_win_auction, only: :update



  def create
    if @bid.save
      ActionCable.server.broadcast "draft_#{@bid.draft.id}",
        bid: render(partial: 'bids/bid.json', locals: { bid: @bid })
    else
      flash[:danger] = "Issue with bid"
      redirect_to request.referer
    end
  end

  def update
    @draft = @bid.draft
    @user = @bid.user
    @top_remaining = Player.top_remaining(@draft.year)[0..30]
    if @bid.update_attributes(bid_params)
      @draft.update_attribute(:nominated_player_id, nil)
      @draft.set_next_nominating_user
      @top_remaining = Player.top_remaining(@draft.year)[0..30]
      ActionCable.server.broadcast "draft_#{@draft.id}",
        sold_player: render(partial: 'sold_player', locals: { user: @user, draft: @draft  })
    else
      flash[:danger] = "Winning bid could not be resolved"
      redirect_to request.referer
    end
  end

  def destroy
    Bid.find(params[:id]).destroy
    flash[:success] = "Bid deleted"
    redirect_to request.referer || root_url
  end


  def index
    @bids = Bid.all
  end

  private ####################

  def bid_params
    params.require(:bid).permit(:draft_id, :player_id, :user, :amount, :winning)
  end

  def user_is_auctioneer
    flash[:danger] = "User not auctioneer" unless current_user.auctioneer?
    redirect_to drafts_path unless current_user.auctioneer?
  end

  def auctioneer_cant_win_auction
    @bid = Bid.last
    flash[:danger] = "Auctioneer can't win auction" unless current_user.auctioneer?
    redirect_to (request.referer || root_url) unless !@bid.user.auctioneer
  end

  def not_winning
    @bid = current_user.bids.build(bid_params)
    @bid.winning = false
  end

  def check_if_enough_money
    money_remaining = current_user.money_remaining(@bid.draft.year)
    puts money_remaining
    if @bid.amount > money_remaining
      flash[:alert] = "You dont have enough money!"
      redirect_to draft_path(@bid.draft)
    end
  end

  def check_if_top_bid
    high_bid = @bid.draft.highest_bid_amount(@bid.player)
    if high_bid
      if @bid.amount <= high_bid
        flash[:danger] = "Bid needs to be higher!"
        redirect_to draft_path(@bid.draft)
      end
    end
  end




end
