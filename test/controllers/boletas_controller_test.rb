require 'test_helper'

class BoletasControllerTest < ActionController::TestCase
  test "should get ok" do
    get :ok
    assert_response :success
  end

  test "should get fail" do
    get :fail
    assert_response :success
  end

end
