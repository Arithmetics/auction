require 'test_helper'

class DraftTest < ActiveSupport::TestCase

  setup do
    @draft2018 = drafts(:six)
    @player1 = players(:one)
    @player2 = players(:two)
    @user1 = users(:one)
    @bid1 = bids(:one)
    @bid2 = bids(:two)
    @bid3 = bids(:three)
  end

  test "draft needs year" do
    @new_draft = Draft.new(
      format: "OP_standard",
      open: false,
      nominated_player_id: nil
    )
    assert_not @new_draft.valid?
  end

  test "draft needs format" do
    @new_draft = Draft.new(
      year: 2012,
      open: false,
      nominated_player_id: nil
    )
    assert_not @new_draft.valid?
  end

  test "draft is valid" do
    @new_draft = Draft.new(
      year: 2012,
      format: "OP_standard",
      open: false,
      nominated_player_id: nil
    )
    assert @new_draft.valid?
  end

  test "nominated_player returns correct player" do
    assert @draft2018.nominated_player == @player1
  end


  test "highest bid amount is correct bid" do
    assert @draft2018.bids.where(:player == @player1).count == 3
    assert_equal @draft2018.bids.first.amount, 3
    assert_equal @draft2018.bids.second.amount, 2
    assert_equal @draft2018.bids.third.amount, 1
    assert_equal @draft2018.bids.where(:player == @player1).maximum('amount'), 3
  end


end
