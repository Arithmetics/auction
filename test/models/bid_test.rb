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
  end

  test "valid bid has user" do
    @new_bid = Bid.new(
      draft: @draft2018,
      player: @player1,
      user: @user1,
      winning: false
    )

    assert_not @new_bid.valid?
  end





end
