require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  
  def setup
    @street = '1311 Marion St.'
    @city   = 'Denver'
    @state  = 'CO'
    @zip    = '80218'
    @loc = Location.new({
      :street => @street,
      :city   => @city,
      :state  => @state,
      :zip    => @zip})
  end
  
  # Test that we can instantiate the class
  test "instantiation" do
    assert_instance_of Location, @loc, "Is not a Location object"
  end
  
  # Test that we can get back the input values from the attr_readers
  test "attr_readers" do
    assert_equal @street, @loc.street, "Does not return the correct street"
    assert_equal @city, @loc.city, "Does not return the correct city"
    assert_equal @state, @loc.state, "Does not return the correct state"
    assert_equal @zip, @loc.zip, "Does not return the correct ZIP"
  end
  
  test "initial_status" do
    assert_equal Location::STATUS_NOT_GEOCODED, @loc.status, "Does not return correct initial status"
  end
  
  # Ensure we have an immutable value object
  # TODO: Use reflection to iterate over all attr_readers
  test "value_object" do
    assert !@loc.respond_to?('street='), "Is not an immutable value object"
    assert !@loc.respond_to?('city='), "Is not an immutable value object"
    assert !@loc.respond_to?('state='), "Is not an immutable value object"
    assert !@loc.respond_to?('zip='), "Is not an immutable value object"
    assert !@loc.respond_to?('country='), "Is not an immutable value object"
    assert !@loc.respond_to?('lat='), "Is not an immutable value object"
    assert !@loc.respond_to?('lng='), "Is not an immutable value object"
    assert !@loc.respond_to?('status='), "Is not an immutable value object"
  end
  
  test "responds_to_geocode" do
    assert_respond_to @loc, :geocode!, "Does not have a geocode! method"
  end
  
  test "status_after_geocoding" do
    @loc.geocode!
    assert_equal Location::STATUS_GEOCODED, @loc.status, "Did not return successful status after geocoding"
  end
  
  # Test the post-geocoding attr_readers
  test "geocoding" do
    @loc.geocode!
    assert_equal 39.737157, @loc.lat, "Did not return correct latitude"
    assert_equal -104.972026, @loc.lng, "Did not return correct longitude"
    assert_equal '1311 Marion St', @loc.street, "Did not return correct street"
    assert_equal 'Denver', @loc.city, "Did not return correct city"
    assert_equal 'CO', @loc.state, "Did not return correct state"
    assert_equal '80218-2208', @loc.zip, "Did not return correct ZIP"
    assert_equal 'US', @loc.country, "Did not return correct country"
  end
end
