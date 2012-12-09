require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

end
