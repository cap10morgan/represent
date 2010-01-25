require 'test_helper'

class LegislatorsControllerTest < ActionController::TestCase
  test "should_get_index" do
    get :index
    assert_response :success
    assert_template :find
  end
  
  test "should_get_find_form" do
    get :find
    assert_response :success
    assert_template :find
  end
  
  test "should_get_legislators_for_zip" do
    get :zip, {'zip' => '80218-2208'}
    assert_response :success
    assert_template :zip
    assert_not_nil assigns(:legislators)
  end
  
  test "handle_empty_set_correctly" do
    get :zip, {'zip' => '80218-1178'}
    assert_response :success
    assert_template :find
    assert_match /^No legislators found/, flash[:notice]
  end
    
  test "can_view_single_legislator" do
    get :show, {'id' => '561'}
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:leg)
  end
end
