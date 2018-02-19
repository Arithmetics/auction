class Player < ApplicationRecord
  has_many :games
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
    response = open('http://api.fantasy.nfl.com/v1/players/userdraftranks?format=json').read
    ranking_object = JSON.parse(response)
    unsold_list = self.unsold(year)
    top_ranked_left = []

    ranking_object["players"][0..75].each do |player|
      if unsold_list.select{|x| x.esbid == player["esbid"]}.length > 0
        top_ranked_left.push(player["firstName"] + " " + player["lastName"] + ", " + player["position"]);
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

  def sales_hash
    graph_data = {}
    Draft.all.each do |draft|
      year = draft.year
      winning_bid = draft.bids.find_by(player_id: self.id, winning: true)
      if winning_bid
        graph_data[year.to_s] = winning_bid.amount
      end
    end
    graph_data.sort.to_h
  end

  def season_pts_hash
    graph_data = {}
    Draft.all.each do |draft|
      year = draft.year
      player_games = self.games.where(season: year)
      if player_games.count > 0
        season_fantasy_points = player_games.reduce(0){|sum,x| sum + x.points_standard }
        graph_data[year.to_s] = season_fantasy_points.round(1)
      end
    end
    graph_data.sort.to_h
  end

  def games_played_hash
    graph_data = {}
    Draft.all.each do |draft|
      year = draft.year
      player_games = self.games.where(season: year)
      if player_games.count > 0
        games
        graph_data[year.to_s] = player_games.count
      end
    end
    graph_data.sort.to_h
  end

  def points_per_game_hash
    season_pts = season_pts_hash
    games_count = games_played_hash
    graph_data = {}
    season_pts.each do |k,v|
      graph_data[k] = (v/(games_count[k].to_f)).round(2)
    end
    graph_data
  end


end
