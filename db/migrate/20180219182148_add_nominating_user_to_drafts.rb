class AddNominatingUserToDrafts < ActiveRecord::Migration[5.1]
  def change
    add_column :drafts, :nominating_user_id, :integer
  end
end
