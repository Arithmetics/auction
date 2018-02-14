class Game < ApplicationRecord
  #belongs_to :player


  def points_standard
    pts = [
      passing_yards/25.0,
      passing_touchdowns*4.0,
      interceptions_thrown*-2.0,
      rushing_yards/10.0,
      recieving_yards/10.0,
      recieving_touchdowns*6.0,
      return_yards/50.0,
      return_touchdowns*6.0,
      fumbles_recovered_for_touchdown*6.0,
      fumbles_lost*-2.0,
      two_point_conversions*2.0,
      pat_made*1.0,
      pat_missed*-1.0,
      fg_made_0_19*3.0,
      fg_made_20_29*3.0,
      fg_made_30_39*3.0,
      fg_made_40_49*3.0,
      fg_made_50_plus*4.0,
      fg_missed_0_19*-3.0,
      fg_missed_20_29*-2.0,
      fg_missed_30_39*-1.0,
      fg_missed_40_49*-1.0,
      fg_missed_50_plus*-1.0
    ]

    if position == "DEF"
      if pts_allowed == 0
        pts.push(9.0)
      elsif pts_allowed < 7
        pts.push(6.0)
      elsif pts_allowed < 14
        pts.push(3.0)
      elsif pts_allowed < 21
        pts.push(1.0)
      elsif pts_allowed < 28
        pts.push(-3.0)
      else
        pts.push(-6.0)
      end

      if yards_allowed < 200
        pts.push(2.0)
      elsif yards_allowed < 300
        pts.push(1.0)
      elsif yards_allowed < 400
        pts.push(-0)
      elsif yards_allowed < 450
        pts.push(-1.0)
      elsif yards_allowed < 500
        pts.push(-2.0)
      else
        pts.push(-3.0)
      end

      pts.push(sacks*1.0)
      pts.push(interceptions_caught*2.0)
      pts.push(fumbles_recovered*2.0)
      pts.push(safeties*2.0)
      pts.push(defensive_touchdowns*4.0)
      pts.push(blocked_kicks*1.0)
      pts.push(team_return_touchdowns*6.0)
    end
    pts.reduce(0){|sum,x| sum + x }
  end

end
