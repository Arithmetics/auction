require 'test_helper'

class DraftsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  setup do
    @auctioneer = users(:auctioneer)
    @user1 = users(:one)
    @user2 = users(:two)
    @user3 = users(:three)
    @draft2015 = drafts(:three)
    @draft2016 = drafts(:four)
    @draft2018 = drafts(:six)
    @player1 = players(:one)
    @player2 = players(:two)
    @player3 = players(:three)
    @bid1 = bids(:one)
    @bid2 = bids(:two)
    @bid3 = bids(:three)
  end

  test 'should get index' do
    assert sign_in @user1
    get drafts_path
    assert_response :success
  end

  test "only auctioneer can create draft" do
    sign_in @user2
    assert_no_difference 'Draft.count' do
      post drafts_path, params: { draft: {
          year: 2020,
          format: "Standard",
          nominated_player_id: nil,
          open: false } }
    end
    sign_out @user2
    sign_in @auctioneer
    assert_difference 'Draft.count', 1 do
      post drafts_path, params: { draft: {
          year: 2020,
          format: "Standard",
          nominated_player_id: nil,
          open: false } }
    end
  end

  test "only auctioneer can view new draft" do
    sign_in @user3
    get new_draft_path
    assert_redirected_to root_url
    sign_out @user3
    sign_in @auctioneer
    get new_draft_path
    assert_response :success
  end

  test "only auctioneer can view edit draft" do
    sign_in @user3
    get edit_draft_path(@draft2018)
    assert_redirected_to root_url
    sign_out @user3
    sign_in @auctioneer
    get edit_draft_path(@draft2018)
    assert_response :success
  end

  test "only auctioneer can update draft" do
    sign_in @user2
    patch draft_path(@draft2018), params: { draft: {
            open: false } }
    assert_redirected_to root_url
    @draft2018.reload
    assert @draft2018.open
    sign_out @user2
    sign_in @auctioneer
    patch draft_path(@draft2018), params: { draft: {
            open: false } }
    @draft2018.reload
    assert !@draft2018.open
  end

  test "only auctioneer can undo_drafting in a draft" do
    sign_in @user2
    assert_equal @user2.bids.count, 0
    post bids_path, params: { bid: {
        player_id: @player3.id,
        draft_id: @draft2018.id,
        winning: false,
        amount: 10 } }
    @last_bid = @user2.bids.last
    sign_out @user2
    sign_in @auctioneer
    patch bid_path(@last_bid), params: { bid: {
            winning: true } }
    assert @user2.drafted_players(2018).count == 1
    sign_out @auctioneer
    sign_in @user2
    patch undo_drafting_draft_path(@draft2018), params: { draft:{
      player_id: @player3.id,
      year: @draft2018.year,
      draft_id: @draft2018.id
      }}
    assert @user2.drafted_players(2018).count == 1
    sign_out @user2
    sign_in @auctioneer
    patch undo_drafting_draft_path(@draft2018), params: { draft:{
      player_id: @player3.id,
      year: @draft2018.year,
      draft_id: @draft2018.id
      }}
    assert @user2.drafted_players(2018).count == 0
  end

  test "only auctioneer can unnominate a player in a draft" do
    sign_in @user1
    @draft2018.update_attribute(:nominated_player_id, nil)
    assert_equal @draft2018.nominating_user, @user1
    patch nominate_draft_path(@draft2018), params: { draft: {
      nominated_player_id: @player3.id
      }}
    patch unnominate_draft_path(@draft2018)
    assert_equal @draft2018.nominated_player_id, nil

  end

  test "draft must be open to show" do
    sign_in @user2
    get draft_path(@draft2015)
    assert_redirected_to root_path
    get draft_path(@draft2016)
    assert_response :success
  end

  test "only correct user can nominate a player" do
    sign_in @user2
    @draft2018.update_attribute(:nominated_player_id, nil)
    assert_equal @draft2018.nominating_user, @user1
    patch nominate_draft_path(@draft2018), params: { draft: {
      nominated_player_id: @player3.id
      }}
    @draft2018.reload
    assert_equal @draft2018.nominated_player_id, nil
    sign_out @user2
    sign_in @user1
    assert_equal @draft2018.nominating_user, @user1
    patch nominate_draft_path(@draft2018), params: { draft: {
      nominated_player_id: @player3.id
      }}
    @draft2018.reload
    assert_equal @draft2018.nominated_player_id, @player3.id
  end



end
