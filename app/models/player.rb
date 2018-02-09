class Player < ApplicationRecord
  #has_many :games
  has_many :bids
  has_many :users, through: :bids
  has_many :drafts, through: :bids

  def self.unsold(year)
    unsold_players = []
    Player.all.each do |player|
      if !player.sold?(year)
        unsold_players << player
      end
    end
    unsold_players.sort!{|x,y| x.player_name <=> y.player_name}
  end


  def name_with_position
    "#{self.player_name}, #{self.games.last.position}"
  end

  def sold?(year)
    sold = false
    self.bids.each do |bid|
      if bid.winning && bid.draft.year == year
        sold = true
      end
    end
    sold
  end

end
