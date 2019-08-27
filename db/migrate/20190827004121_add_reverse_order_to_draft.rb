class AddReverseOrderToDraft < ActiveRecord::Migration[5.1]
  def change
    add_column :drafts, :reverseOrder, :boolean
  end
end
