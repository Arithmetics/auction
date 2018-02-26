json.(bid, :id, :amount)
json.user do
  json.extract! bid.user, :id, :name, :auctioneer
end
