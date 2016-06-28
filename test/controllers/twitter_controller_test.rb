require 'test_helper'

class TwitterControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get publish" do
    get :publish
    assert_response :success
  end

end
