class CreateDrafts < ActiveRecord::Migration[5.1]
  def change
    create_table :drafts do |t|
      t.integer :year
      t.string :format

      t.timestamps
    end
  end
end
