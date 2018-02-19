class Draft < ApplicationRecord
  has_many :bids
  has_many :players, through: :bids
  has_many :users, through: :bids

  validates :format, presence: true
  validates :year, presence: true



  def nominated_player
    if self.nominated_player_id
      nom_player = Player.find(self.nominated_player_id)
    else
      nom_player = nil
    end
    nom_player
  end


  def nominating_user
    if self.nominating_user_id
      nom_user = User.find(self.nominating_user_id)
    else
      nom_user = nil
    end
    nom_user
  end

  def set_next_nominating_user
    if !self.nominating_user_id || self.nominating_user_id == User.count
      self.update_attribute(:nominating_user_id, User.first.id)
    else
      found = false
      until found
        current_nomination_id = self.nominating_user_id
        self.update_attribute(:nominating_user_id, current_nomination_id + 1)
        if User.find(self.nominating_user_id)
          found = true
        end
      end
    end
    if User.find(self.nominating_user_id).auctioneer
      self.set_next_nominating_user
    end 
  end


  def highest_bid_amount(player)
    self.bids.where(player: player).maximum('amount')
  end

end
