require 'open-uri'
require 'json'

##############seasons seed################

def api_request(week, season, position)
  response = open("http://api.fantasy.nfl.com/v1/players/stats?statType=weekStats&season=#{season}&week=#{week}&position=#{position}&format=json").read
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

seasons = Array(2013..2017)

positions = ["QB", "RB", "TE", "DEF", "WR", "K"]

weeks.each do |week|
  seasons.each do |season|
    positions.each do |position|


      game_obj = api_request(week, season, position)
      players = game_obj["players"]

      players.each do |player|

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


#######players seed###################
player_list = []
Game.all.each do |game|
  player_list.push([game.player_id, game.esbid, game.gsisPlayerId, game.player_name, game.position])
end

unique_players = player_list.uniq

unique_players.each do |player|
  new_player =  Player.new(
                  esbid: player[1],
                  gsisPlayerId: player[2],
                  player_name: player[3],
                  position: player[4]
                )
  new_player.id = player[0]
  puts new_player
  new_player.save!
end


#####drafts seed ###############
years = [2013,2014,2015,2016,2017]

years.each do |year|
  Draft.create(
    year: year,
    format: "OP_standard",
    open: false,
    nominated_player_id: nil
  )
end


#######users seed #########
