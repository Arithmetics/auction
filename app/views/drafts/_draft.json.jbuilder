json.(draft, :year, :id)

json.bids(draft.bids.where(player: draft.nominated_player).order(:amount).reverse) do |bid|
  json.extract! bid, :id, :amount
  json.user do
    json.extract! bid.user, :id, :name, :auctioneer
  end
end

if draft.nominated_player

  json.nominated_player(draft.nominated_player, :id, :esbid, :gsisPlayerId, :player_name, :position, :master_graphs_hash)


end

json.users(users) do |user|
  json.extract! user, :id, :name
  json.team(user.drafted_players(draft.year) do |player|
    json.extract! player, :player_name, :position
  end)
  json.money_remaining(user.money_remaining(draft.year))
end

json.auctioneer(current_user.auctioneer)

json.nominating_user(draft.nominating_user, :id, :name)

json.current_user(current_user, :id, :name)

json.unsold_players(unsold_players) do |player|
  json.extract! player, :id, :player_name, :position
end
