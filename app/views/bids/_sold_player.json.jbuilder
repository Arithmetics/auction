json.extract! user, :id, :name
json.team(user.drafted_players(draft.year) do |player|
  json.extract! player, :player_name, :position, :esbid
end)
json.money_remaining(user.money_remaining(draft.year))

json.nominating_user(draft.nominating_user, :id, :name)
