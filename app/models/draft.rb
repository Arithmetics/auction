class Draft < ApplicationRecord
  has_many :bids
  has_many :players, through: :bids
  has_many :users, through: :bids

  validates :format, presence: true
  validates :year, presence: true



  def nominated_player
    if self.nominated_player_id != nil
      if self.nominated_player_id == 0
        nom_player = nil
      else
        nom_player = Player.find(self.nominated_player_id)
      end
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

    # no nom user or at the end
    if !self.nominating_user_id || self.nominating_user_id == User.count && !self.reverseOrder
      self.update_attribute(:reverseOrder, true)
      self.update_attribute(:nominating_user_id, User.last.id)
    elsif self.nominating_user_id == 1
      if self.reverseOrder 
        self.update_attribute(:nominating_user_id, User.first.id)
        self.update_attribute(:reverseOrder, false)
      else
        self.update_attribute(:nominating_user_id, User.second.id)
      end
    else
      found = false
      until found
        current_nomination_id = self.nominating_user_id
        if self.reverseOrder
          self.update_attribute(:nominating_user_id, current_nomination_id - 1)
        else
          self.update_attribute(:nominating_user_id, current_nomination_id + 1)
        end
        if User.find(self.nominating_user_id)
          found = true
        end
      end
    end

    # conditions to move on if auctioneer or out of money
    if User.find(self.nominating_user_id).auctioneer
      self.set_next_nominating_user
    elsif User.find(self.nominating_user_id).money_remaining(self.year) < 1
      self.set_next_nominating_user
    end
  end


  def highest_bid_amount(player)
    self.bids.where(player: player).maximum('amount')
  end

end
