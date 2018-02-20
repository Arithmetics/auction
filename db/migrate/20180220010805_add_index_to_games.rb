class AddIndexToGames < ActiveRecord::Migration[5.1]
  def change
    add_index :games, :player_id
  end
end
