require 'test_helper'

class BidsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @auctioneer = users(:auctioneer)
    @user1 = users(:one)
    @user2 = users(:two)
    @user3 = users(:three)
    @draft2018 = drafts(:six)
    @player1 = players(:one)
    @player2 = players(:two)
    @player3 = players(:three)
    @bid1 = bids(:one)
    @bid2 = bids(:two)
    @bid3 = bids(:three)
  end

  test 'sign in test for devise' do
    assert sign_in @user1
  end

  test "check bid is changed to not winning upon submission" do
    assert sign_in @user2
    assert_equal @user2.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: true,
        amount: 5
    } }
    assert_equal @user2.bids.count, 1
    assert_equal @user2.bids.last.player, @player3
    assert !@user2.bids.last.winning
  end

  test "check bid is not over users money limit upon submission" do
    assert sign_in @user2
    assert_equal @user2.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 205 } }
    assert_equal @user2.bids.count, 0
  end

  test "only accepts a higher bid on a player" do
    sign_in @user2
    assert_equal @user2.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 10 } }
    assert_equal @user2.bids.count, 1
    sign_out @user2
    sign_in @user3
    assert_equal @user3.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 11 } }
    assert_equal @user3.bids.count, 1
    sign_out @user3
    sign_in @user2
    assert_equal @user2.bids.count, 1
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 9 } }
    assert_equal @user2.bids.count, 1
    sign_out @user2
  end

  test "only auctioneer set a bid to winning" do
    sign_in @user2
    assert_equal @user2.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 10 } }
    @last_bid = @user2.bids.last
    id = @last_bid.id
    assert_equal @last_bid.player, @player3
    assert_equal @user2.bids.count, 1
    patch bid_path(@last_bid), params: { bid: {
            winning: true } }
    @last_bid.reload
    assert !@last_bid.winning
    assert_redirected_to drafts_path
    sign_out @user2
    sign_in @auctioneer
    patch bid_path(@last_bid), params: { bid: {
            winning: true } }
    @bid = Bid.find(id)
    assert @bid.winning
  end

  test "update to winning should set next nominating_user" do
    sign_in @user2
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 10 } }
    @last_bid = @draft2018.bids.last
    id = @last_bid.id
    sign_out @user2
    sign_in @auctioneer
    last_nom_user = @draft2018.nominating_user
    patch bid_path(@last_bid), params: { bid: {
            winning: true } }
    @draft2018.reload
    assert_nil @draft2018.nominated_player_id
    assert_not_equal @draft2018.nominating_user, @player3
  end

  test "only auctioneer can delete bids" do
    sign_in @user2
    assert_no_difference 'Bid.count' do
      delete bid_path(@bid3)
    end
    sign_out @user2
    sign_in @auctioneer
    assert_difference 'Bid.count', -1 do
      delete bid_path(@bid3)
    end
  end

  test "auctioneer can't win the auction" do
    sign_in @auctioneer
    assert_equal @auctioneer.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 10 } }
    assert_equal @auctioneer.bids.count, 1
    patch bid_path(@auctioneer.bids.last), params: { bid: {
            winning: true } }
    assert_not @auctioneer.bids.last.winning 
  end


end
