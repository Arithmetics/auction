class AddAuctioneerToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auctioneer, :boolean, default: false 
  end
end
