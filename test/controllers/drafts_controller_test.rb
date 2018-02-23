require 'test_helper'

class DraftsControllerTest < ActionDispatch::IntegrationTest
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

  end

  test "only auctioneer can undo_drafting in a draft" do

  end

  test "only auctioneer can unnominate a player in a draft" do

  end

  test "only auctioneer can XXX" do

  end

end
