require 'open-uri'
require 'json'



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
    recieving_yards: "21",
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
    recieving_yards: 0,
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
