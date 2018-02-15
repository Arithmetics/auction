require 'test_helper'

class BidTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @draft2018 = drafts(:six)
    @player1 = players(:one)
    @player2 = players(:two)
    @user1 = users(:one)
    @bid1 = bids(:one)
  end

  test "bid must have amount" do
    @new_bid = Bid.new(
      draft: @draft2018,
      player: @player1,
      user: @user1,
      winning: false
    )
    assert_not @new_bid.valid?
  end


  test "bid must have draft" do
    @new_bid = Bid.new(
      amount: 23,
      player: @player1,
      user: @user1,
      winning: false
    )
    assert_not @new_bid.valid?
  end


  test "bid must have user" do
    @new_bid = Bid.new(
      amount: 23,
      draft: @draft2018,
      player: @player1,
      winning: false
    )
    assert_not @new_bid.valid?
  end

  test "bid must have player" do
    @new_bid = Bid.new(
      amount: 23,
      draft: @draft2018,
      user: @user1,
      winning: false
    )
    assert_not @new_bid.valid?
  end


  test "valid bid has user" do
    @new_bid = Bid.new(
      amount: 23,
      draft: @draft2018,
      player: @player1,
      winning: false
    )
    assert_not @new_bid.valid?

  end

  test "bid is connected to player" do
    assert_equal @bid1.player, @player2
  end




end
