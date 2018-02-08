class BidsController < ApplicationController
  before_action :not_winning, :check_if_enough_money, :check_if_top_bid, only: :create
  before_action :user_is_auctioneer, only: [:destroy, :update]

  def create
    if @bid.save
      ActionCable.server.broadcast 'draft_channel',
        bid: render(partial: 'drafts/bid', locals: { bid: @bid }),
        leading: @bid.user.name, amount: @bid.amount
    else
      redirect_to request.referer
    end
  end

  def update
    @bid = Bid.last
    puts "XXXXXXXXX" + @bid.id.to_s
    @draft = @bid.draft
    puts "YYYYYYYYY" + @draft.id.to_s
    if @bid.update_attributes(bid_params)
      @draft.update_attribute(:nominated_player_id, nil)

      ActionCable.server.broadcast 'draft_channel',
        nomination: render(partial: 'drafts/nomination', locals: { draft: @draft })

      #redirect_to request.referer

    else
      redirect_to request.referer
    end
  end

  def destroy
    Bid.find(params[:id]).destroy
    flash[:success] = "Bid deleted"
    redirect_to request.referer
  end




  private ####################

  def bid_params
    params.require(:bid).permit(:draft_id, :player_id, :user, :amount, :winning)
  end

  def user_is_auctioneer
    redirect_to request.referer unless current_user.auctioneer?
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
    if @bid.amount <= high_bid
      redirect_to draft_path(@bid.draft)
    end
  end


end
