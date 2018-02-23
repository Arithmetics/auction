require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  setup do
    @draft2018 = drafts(:six)
    @player1 = players(:one)
    @player2 = players(:two)
    @player3 = players(:three)
    @user1 = users(:one)
    @bid1 = bids(:one)
    @bid2 = bids(:two)
    @bid3 = bids(:three)
  end



  test "player must have gsisPlayerId" do
    @new_player = Player.new(
      esbid: 34234,
      player_name: "Bringo Brangus",
      position: "QB"
    )
    assert_not @new_player.valid?
  end


  test "player must have player_name" do
    @new_player = Player.new(
      esbid: 34234,
      gsisPlayerId: "DFG435",
      position: "QB"
    )
    assert_not @new_player.valid?
  end


  test "player must have position" do
    @new_player = Player.new(
      esbid: 34234,
      gsisPlayerId: "DFG435",
      player_name: "Bringo Brangus"
    )
    assert_not @new_player.valid?
  end


  test "valid player" do
    @new_player = Player.new(
      esbid: 34234,
      gsisPlayerId: "DFG435",
      player_name: "Bringo Brangus",
      position: "QB"
    )
    assert @new_player.valid?
  end


  test "player has bids" do
    assert_equal @player2.bids.count, 5
  end


  test "player without winning bid is not sold" do
    assert_not @player1.sold?(2018)
    assert_not @player2.sold?(2018)
  end


  test "player becomes sold when bid is winning" do
    assert_not @player2.sold?(2018)
    @player2.bids.first.update_attribute(:winning, true)
    assert @player2.bids.first.winning == true
    assert @player2.sold?(2018)
  end


  test "player list should shorten when player is sold" do
    assert_not @player2.sold?(2018)
    assert_equal Player.unsold(2018).count, 3
    @player2.bids.first.update_attribute(:winning, true)
    assert @player2.sold?(2018)
    assert_equal Player.unsold(2018).count, 2
  end


  test "correct sell amount reported" do
    @player2.bids.first.update_attribute(:winning, true)
    assert @player2.sold?(2018)
    assert_equal @player2.sell_amount(2018), 3
  end


  test "prints name with position" do
    assert_equal @player1.name_with_position, "Marshawn Lynch, RB"
  end


  test "connects with games" do
    assert_equal @player3.games.count, 6
  end


  test "season_pts_hash" do
    assert_equal @player3.master_graphs_hash[:season_pts]["2013"], 147.3
  end

  test "sales_hash" do
    assert_equal @player2.master_graphs_hash[:sales]["2014"], 5
    assert_equal @player2.master_graphs_hash[:sales]["2015"], 6
  end

  test "games_played_hash" do
    assert_equal @player3.master_graphs_hash[:games_played]["2013"], 6
  end


end
