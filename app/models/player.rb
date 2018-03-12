class Player < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :bids
  has_many :users, through: :bids
  has_many :drafts, through: :bids


  validates :gsisPlayerId, presence: true
  validates :player_name, presence: true
  validates :position, presence: true

  def sold?(year)
    sold = false
    self.bids.each do |bid|
      if bid.winning && bid.draft.year == year
        sold = true
      end
    end
    sold
  end


  def self.unsold(year)
    bids = Draft.find_by(year: year).bids.all
    all_players = Player.all.to_a
    sold_players = []
    bids.where(winning: true).each do |winning_bid|
      sold_players << winning_bid.player
    end
    unsold_players = all_players - sold_players
    unsold_players.sort!{|x,y| x.player_name <=> y.player_name}
    return unsold_players
  end

  #saving for posterity. what a bad method!!
  def self.old_unsold(year)
    unsold_players = []
    Player.all.each do |player|
      if !player.sold?(year)
        unsold_players << player
      end
    end
    unsold_players.sort!{|x,y| x.player_name <=> y.player_name}
  end

  def self.top_remaining(year)
    require 'open-uri'
    require 'json'
    response = open('http://api.fantasy.nfl.com/v1/players/userdraftranks?format=json&count=100').read
    ranking_object = JSON.parse(response)
    unsold_list = self.unsold(year)
    top_ranked_left = []
    ranking_object["players"][0..99].each do |player|
      if unsold_list.select{|x| x.esbid == player["esbid"]}.length > 0
        top_ranked_left.push(player);
      end
    end
    response = open('http://api.fantasy.nfl.com/v1/players/userdraftranks?format=json&count=100&offset=100').read
    ranking_object = JSON.parse(response)
    unsold_list = self.unsold(year)
    ranking_object["players"][0..99].each do |player|
      if unsold_list.select{|x| x.esbid == player["esbid"]}.length > 0
        top_ranked_left.push(player);
      end
    end
    top_ranked_left
  end

  def name_with_position
    "#{self.player_name}, #{self.position}"
  end

  def sell_amount(year)
    amount = 0
    self.bids.each do |bid|
      if bid.winning && bid.draft.year == year
        amount = bid.amount
      end
    end
    amount
  end

  def master_graphs_hash
    master_graph_data = {
      sales: [], season_pts: [], games_played: [], pts_per_game: []
    }
    Draft.all.each do |draft|
      year = draft.year
      #sales_hash
      winning_bid = draft.bids.find_by(player_id: self.id, winning: true)
      if winning_bid
        master_graph_data[:sales].push({year: year.to_s, amount: winning_bid.amount, user: winning_bid.user.name })
      end
      #season_pts_hash
      player_games = self.games.where(season: year)
      if player_games.count > 0
        season_fantasy_points = player_games.reduce(0){|sum,x| sum + x.points_standard }
        master_graph_data[:season_pts].push({year: year.to_s, season_fantasy_points: season_fantasy_points.round(1) })
      end
      #games_played_hash
      year = draft.year
      player_games = self.games.where(season: year)
      if player_games.count > 0
        games
        master_graph_data[:games_played].push({year: year.to_s, games_played: player_games.count})
      end

    end

    #pts/game_hash
    master_graph_data[:season_pts].each_with_index do |x,i|
      master_graph_data[:pts_per_game].push({year: x[:year], pts_per_game: (x[:season_fantasy_points]/(master_graph_data[:games_played][i][:games_played].to_f)).round(2) } )
    end


    master_graph_data
  end

end
