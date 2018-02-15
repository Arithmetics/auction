require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  setup do
    @draft2018 = drafts(:six)
    @player1 = players(:one)
    @player2 = players(:two)
    @user1 = users(:one)
    @bid1 = bids(:one)
    @bid2 = bids(:two)
    @bid3 = bids(:three)
  end

  test "player must have esbid" do
    @new_player = Player.new(
      gsisPlayerId: "DFG435",
      player_name: "Bringo Brangus",
      position: "QB"
    )
    assert_not @new_player.valid?
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
    assert_equal @player2.bids.count, 3
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


  test "prints name with position" do
    assert_equal @player1.name_with_position, "Marshawn Lynch, RB"
  end





end
