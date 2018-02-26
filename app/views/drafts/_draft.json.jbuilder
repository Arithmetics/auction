json.(draft, :year, :id)
json.bids(draft.bids.where(player: draft.nominated_player).order(:amount).reverse) do |bid|
  json.extract! bid, :id, :amount
  json.user do
    json.extract! bid.user, :id, :name, :auctioneer
  end
end
