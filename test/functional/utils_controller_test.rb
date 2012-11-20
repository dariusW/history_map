require 'test_helper'

class UtilsControllerTest < ActionController::TestCase
  test "should get date" do
    get :date
    assert_response :success
  end

end
