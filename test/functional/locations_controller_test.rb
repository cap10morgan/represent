require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template :address_form
  end

  test "address should redirect to legislators" do
    get :index, {:addr1 => '1311 Marion St.', :addr2 => '', :city => 'Denver', 
      :state => 'CO', :zip => '80218'}
    assert_redirected_to '/legislators/zip/80218-2208'
  end
end
