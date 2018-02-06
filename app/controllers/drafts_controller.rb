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


end
