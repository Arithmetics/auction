require 'open-uri'
require 'json'
require 'csv'





############## games and player seed ################

def api_request(week, season, position)
  puts "making api request for #{week} #{season}, #{position}"
  response = open("https://api.fantasy.nfl.com/v1/players/stats?statType=weekStats&season=#{season}&week=#{week}&position=#{position}&format=json").read
  week_object = JSON.parse(response)
end

def convert_player_stats(player_stats)
  key_key = {
    passing_attempts: "2",
    passing_completions: "3",
    passing_yards: "5",
    passing_touchdowns: "6",
    interceptions_thrown: "7",
    rushing_attempts: "13",
    rushing_yards: "14",
    rushing_touchdowns: "15",
    receptions: "20",
    receiving_yards: "21",
    receiving_touchdowns: "22",
    return_yards: "27",
    return_touchdowns: "28",
    fumbles_recovered_for_touchdown: "29",
    fumbles_lost: "30",
    two_point_conversions: "32",
    pat_made: "33",
    pat_missed: "34",
    fg_made_0_19: "35",
    fg_made_20_29: "36",
    fg_made_30_39: "37",
    fg_made_40_49: "38",
    fg_made_50_plus: "39",
    fg_missed_0_19: "40",
    fg_missed_20_29: "41",
    fg_missed_30_39: "42",
    fg_missed_40_49: "43",
    fg_missed_50_plus: "44",
    sacks: "45",
    interceptions_caught: "46",
    fumbles_recovered: "47",
    safeties: "49",
    defensive_touchdowns: "50",
    blocked_kicks: "51",
    team_return_yards: "52",
    team_return_touchdowns: "53",
    points_allowed: "54",
    yards_allowed: "62",
    team_two_pt_return: "93",
  }

  converted = {
    passing_attempts: 0,
    passing_completions: 0,
    passing_yards: 0,
    passing_touchdowns: 0,
    interceptions_thrown: 0,
    rushing_attempts: 0,
    rushing_yards: 0,
    rushing_touchdowns: 0,
    receptions: 0,
    receiving_yards: 0,
    receiving_touchdowns: 0,
    return_yards: 0,
    return_touchdowns: 0,
    fumbles_recovered_for_touchdown: 0,
    fumbles_lost: 0,
    two_point_conversions: 0,
    pat_made: 0,
    pat_missed: 0,
    fg_made_0_19: 0,
    fg_made_20_29: 0,
    fg_made_30_39: 0,
    fg_made_40_49: 0,
    fg_made_50_plus: 0,
    fg_missed_0_19: 0,
    fg_missed_20_29: 0,
    fg_missed_30_39: 0,
    fg_missed_40_49: 0,
    fg_missed_50_plus: 0,
    sacks: 0,
    interceptions_caught: 0,
    fumbles_recovered: 0,
    safeties: 0,
    defensive_touchdowns: 0,
    blocked_kicks: 0,
    team_return_yards: 0,
    team_return_touchdowns: 0,
    points_allowed: 0,
    yards_allowed: 0,
    team_two_pt_return: 0,
  }

  player_stats.each do |stat_key, stat_value|
    new_key = key_key.key(stat_key)
    if !!converted[new_key]
      converted[new_key] = stat_value.to_i
    end
  end
  converted
end


weeks = Array(1..17)

seasons = Array(2013..2018)

positions = ["QB", "RB", "TE", "DEF", "WR", "K"]

weeks.each do |week|
  seasons.each do |season|
    positions.each do |position|
      puts "#{week}, #{season}, #{position}"

      game_obj = api_request(week, season, position)
      players = game_obj["players"]

      players.each do |player|

        if Player.where(id: player["id"].to_i).empty?
          new_player =  Player.new(
            esbid: player["esbid"],
            gsisPlayerId: player["gsisPlayerId"],
            player_name: player["name"],
            position: player["position"],
          )
          new_player.id = player["id"].to_i
          puts new_player
          new_player.save!
        end

        converted_stats = convert_player_stats(player["stats"])

        Game.create(
          season: season,
          week: week,
          player_id: player["id"].to_i,

          esbid: player["esbid"],
          gsisPlayerId: player["gsisPlayerId"],
          player_name: player["name"],
          position: player["position"],
          team: player["teamAbbr"],

          passing_attempts: converted_stats[:passing_attempts],
          passing_completions: converted_stats[:passing_completions],
          passing_yards: converted_stats[:passing_yards],
          passing_touchdowns: converted_stats[:passing_touchdowns],
          interceptions_thrown: converted_stats[:interceptions_thrown],
          rushing_attempts: converted_stats[:rushing_attempts],
          rushing_yards: converted_stats[:rushing_yards],
          rushing_touchdowns: converted_stats[:rushing_touchdowns],
          receptions: converted_stats[:receptions],
          receiving_yards: converted_stats[:receiving_yards],
          receiving_touchdowns: converted_stats[:receiving_touchdowns],
          return_yards: converted_stats[:return_yards],
          return_touchdowns: converted_stats[:return_touchdowns],
          fumbles_recovered_for_touchdown: converted_stats[:fumbles_recovered_for_touchdown],
          fumbles_lost: converted_stats[:fumbles_lost],
          two_point_conversions: converted_stats[:two_point_conversions],
          pat_made: converted_stats[:pat_made],
          pat_missed: converted_stats[:pat_missed],
          fg_made_0_19: converted_stats[:fg_made_0_19],
          fg_made_20_29: converted_stats[:fg_made_20_29],
          fg_made_30_39: converted_stats[:fg_made_30_39],
          fg_made_40_49: converted_stats[:fg_made_40_49],
          fg_made_50_plus: converted_stats[:fg_made_50_plus],
          fg_missed_0_19: converted_stats[:fg_missed_0_19],
          fg_missed_20_29: converted_stats[:fg_missed_20_29],
          fg_missed_30_39: converted_stats[:fg_missed_30_39],
          fg_missed_40_49: converted_stats[:fg_missed_40_49],
          fg_missed_50_plus: converted_stats[:fg_missed_50_plus],
          sacks: converted_stats[:sacks],
          interceptions_caught: converted_stats[:interceptions_caught],
          fumbles_recovered: converted_stats[:fumbles_recovered],
          safeties: converted_stats[:safeties],
          defensive_touchdowns: converted_stats[:defensive_touchdowns],
          blocked_kicks: converted_stats[:blocked_kicks],
          team_return_yards: converted_stats[:team_return_yards],
          team_return_touchdowns: converted_stats[:team_return_touchdowns],
          points_allowed: converted_stats[:points_allowed],
          yards_allowed: converted_stats[:yards_allowed],
          team_two_pt_return: converted_stats[:team_two_pt_return]
        )
      end
    end
  end
end


##### drafts seed ###############
years = [2013,2014,2015,2016,2017]

years.each do |year|
  Draft.create(
    year: year,
    format: "OP_standard",
    open: false,
    nominated_player_id: nil,
    nominating_user_id: nil,
    reverse: false
  )
end

Draft.create(
  year: 2018,
  format: "OP_half_ppr",
  open: false,
  nominated_player_id: nil,
  nominating_user_id: 2
  reverse: false
)

Draft.create(
  year: 2019,
  format: "OP_half_ppr",
  open: true,
  nominated_player_id: nil,
  nominating_user_id: 2
  reverse: false
)

######### user seed ########

User.create(
  email: "auctioneer@example.com",
  name: "Auctioneer",
  password: "password",
  password_confirmation: "password",
  auctioneer: true
)

User.create(
  email: "jordan@example.com",
  name: "Jordan Highland",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "daniel@example.com",
  name: "Daniel McGunnigle",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "kevin@example.com",
  name: "Kevin Kern",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "joe@example.com",
  name: "Joe Whitaker",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "brock@example.com",
  name: "Brock Tillotson",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "brandon@example.com",
  name: "Brandon Troxel",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "mike@example.com",
  name: "Mike Rich",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "jeremy@example.com",
  name: "Jeremy Abbot",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "keenan@example.com",
  name: "Keenan Lopez",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)


User.create(
  email: "matt@example.com",
  name: "Matt Makarowsky",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "dennis@example.com",
  name: "Dennis Ranck",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

User.create(
  email: "woody@example.com",
  name: "Woody Toms",
  password: "password",
  password_confirmation: "password",
  auctioneer: false
)

















####### bids seed #########

csv_text = File.read(Rails.root.join('lib', 'seeds', 'bids.csv'))
csv = CSV.parse(csv_text)


csv.each do |entry|
  Bid.create(
    amount: entry[2],
    user_id: 1,
    draft_id: (entry[0].to_i - 2012),
    player_id: entry[3],
    winning: true
  )
end





####### rookies ####

rookies = [
  ["Kyler Murray","QB",99901,88801,77701],
  ["Dwayne Haskins","QB",99902,88802,77701],
  ["Daniel Jones","QB",99903,88803,77701],
  ["Josh Jacobs","RB",99904,88804,77701],
  ["David Montgomery","RB",99905,88805,77701],
  ["Miles Sanders","RB",99906,88806,77701],
  ["Devin Singletary","RB",99907,88807,77701],
  ["Darrel Henderson","RB",99908,88808,77701],
  ["Justice Hill","RB",99909,88809,77701],
  ["Darwin Thompson","RB",99910,88810,77701],
  ["Damien Harris","RB",99911,88811,77701],
  ["Tony Pollard","RB",99912,88812,77701],
  ["Alexander Mattison","RB",99913,88813,77701],
  ["DK Metcalf","WR",99914,88814,77701],
  ["N'Keal Harry","WR",99915,88815,77701],
  ["Marquise Brown","WR",99916,88816,77701],
  ["Parris Campell","WR",99917,88817,77701],
  ["TJ Hockenson","TE",99918,88818,77701],
  ["Noah Fant","TE",99919,88819,77701]
]

rookies.each do |rookie|
  player = Player.new(
    player_name: rookie[0],
    position: rookie[1],
    id: rookie[2],
    esbid: rookie[3],
    gsisPlayerId: rookie[4]
  )
  player.save!
end
