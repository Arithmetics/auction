require 'test_helper'

class BidsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @bill = users(:one)
    @auctioneer = users(:auctioneer)
  end

  test 'sign in test for devise' do
    sign_in @bill
    assert current_user
  end


end
