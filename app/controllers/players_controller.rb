class PlayersController < ApplicationController

  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
    @games = @player.games.order(:season).order(:week)
  end


end
