class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bids



  def drafted_players(year)
    players = []
    draft = Draft.find_by(year: year)
    winning_bids = draft.bids.where(winning: true, user_id: self.id)
    winning_bids.each do |bid|
      players.push({player: bid.player, amount: bid.amount})
    end
    players
  end

  def money_remaining(year)
    drafted_players = self.drafted_players(year)
    spent = drafted_players.reduce(0) {|sum, player| sum + player[:amount]}
    200 - spent
  end

  def make_acronym()
    input_string = self.name
    return nil unless input_string
    return 'Not a string' unless input_string.is_a? String
    return 'Not letters' unless (input_string =~ /^[a-z\s]*$/i)
  
    input_string.split(" ").each_with_object(''){|e, m| m << e[0]}.upcase
  end

end
