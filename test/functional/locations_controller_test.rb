require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template :address_form
  end

end
