class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bids


  def drafted_players(year)
    players = []
    draft = Draft.find_by(year: year)
    self.bids.each do |bid|
      if (bid.draft == draft && bid.winning)
        players.push({player: bid.player, amount: bid.amount})
      end
    end
    players
  end

end
