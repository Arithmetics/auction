class AddStatusAndNominatedPlayertoDrafts < ActiveRecord::Migration[5.1]
  def change
    add_column :drafts, :open, :boolean
    add_column :drafts, :nominated_player_id, :integer
  end
end
