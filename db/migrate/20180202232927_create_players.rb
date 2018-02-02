class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|

      t.integer :player_id

      t.string :esbid
      t.string :gsisPlayerId
      t.string :player_name
      t.string :position

      t.timestamps
    end
  end
end
