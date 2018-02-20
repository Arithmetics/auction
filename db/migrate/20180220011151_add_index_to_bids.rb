class AddIndexToBids < ActiveRecord::Migration[5.1]
  def change
    add_index :bids, :player_id
    add_index :bids, :draft_id
    add_index :bids, :user_id
  end
end
