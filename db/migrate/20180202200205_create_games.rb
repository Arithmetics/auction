class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|

      t.integer :season
      t.integer :week
      t.integer :player_id

      t.string :esbid
      t.string :gsisPlayerId
      t.string :player_name
      t.string :position
      t.string :team

      t.integer :passing_attempts
      t.integer :passing_completions
      t.integer :passing_yards
      t.integer :passing_touchdowns
      t.integer :interceptions_thrown
      t.integer :rushing_attempts
      t.integer :rushing_yards
      t.integer :rushing_touchdowns
      t.integer :receptions
      t.integer :receiving_yards
      t.integer :receiving_touchdowns
      t.integer :return_yards
      t.integer :return_touchdowns
      t.integer :fumbles_recovered_for_touchdown
      t.integer :fumbles_lost
      t.integer :two_point_conversions
      t.integer :pat_made
      t.integer :pat_missed
      t.integer :fg_made_0_19
      t.integer :fg_made_20_29
      t.integer :fg_made_30_39
      t.integer :fg_made_40_49
      t.integer :fg_made_50_plus
      t.integer :fg_missed_0_19
      t.integer :fg_missed_20_29
      t.integer :fg_missed_30_39
      t.integer :fg_missed_40_49
      t.integer :fg_missed_50_plus
      t.integer :sacks
      t.integer :interceptions_caught
      t.integer :fumbles_recovered
      t.integer :safeties
      t.integer :defensive_touchdowns
      t.integer :blocked_kicks
      t.integer :team_return_yards
      t.integer :team_return_touchdowns
      t.integer :points_allowed
      t.integer :yards_allowed
      t.integer :team_two_pt_return


      t.timestamps
    end
  end
end
