class Draft < ApplicationRecord
  has_many :bids
  has_many :players, through: :bids
  has_many :users, through: :bids


  def nominated_player
    if self.nominated_player_id
      nom_player = Player.find(self.nominated_player_id)
    else
      nom_player = nil
    end
    nom_player
  end

  def highest_bid_amount(player)
    self.bids.where(player: player).maximum('amount')
  end

end
