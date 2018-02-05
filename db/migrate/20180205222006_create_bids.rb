class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :amount
      t.integer :user_id
      t.integer :draft_id
      t.integer :player_id
      t.boolean :winning, default: false

      t.timestamps
    end
  end
end
