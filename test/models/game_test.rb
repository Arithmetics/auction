require 'test_helper'

class GameTest < ActiveSupport::TestCase

  setup do
    @game1 = games(:one)
    @game2 = games(:two)
    @game3 = games(:three)
    @game4 = games(:four)
    @game5 = games(:five)
    @game6 = games(:six)
    @game7 = games(:seven)
  end


  test "correct fantasy point calculations" do
    assert_equal @game1.points_standard, 20.06
    assert_equal @game2.points_standard, 38.06
    assert_equal @game3.points_standard, 30.06
    assert_equal @game4.points_standard, 10.06
    assert_equal @game5.points_standard, 20.06
    assert_equal @game6.points_standard, 28.96
  end

  test "correct defense fantasy points" do
    assert_equal @game7.points_standard, 26.0
  end

end
