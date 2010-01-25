# Location is an immutable value object. It uses Yahoo's geocoding
# API to look up additional information about a given address.
#
# It doesn't inherit from ActiveRecord::Base because it doesn't use a local
# database for anything. In Rails 3, we should add in the ActiveModel
# validations stuff.
#
# Author:: Wes Morgan (cap10morgan@gmail.com)

class Location
  attr_reader :appid, :street, :city, :state, :zip, :country, :lat, :lng, :status
  
  STATUS_NOT_GEOCODED   = 0
  STATUS_GEOCODED       = 1
  STATUS_GEOCODE_ERROR  = -1
  
  # Initializes a new Location object.
  #
  # * street is the street address (e.g. "123 Main St.")
  # * city is the name of the city (e.g. "Chicago")
  # * state is the postal abbreviation of the state (e.g. IL for Illinois)
  # * zip is the 5-digit ZIP code of the address (e.g. 60613)
  def initialize(params)
    @street = params[:street]
    @city   = params[:city]
    @state  = params[:state]
    @zip    = params[:zip]
    @status = STATUS_NOT_GEOCODED
  end
  
  # Calls the Yahoo! geocoding functions and fills in the appropriate attrs
  # on the object. If we wanted to get fancy, we could lazy-load this the 
  # first time someone calls an attr_reader that needs geocoding. But this 
  # gives the user a bit more control.
  def geocode!
    result = GeoKit::Geocoders::YahooGeocoder.geocode "#{@street}, #{@city}, #{@state} #{@zip}"
    if result.success?
      @street   = result.street_address
      @city     = result.city
      @state    = result.state
      @zip      = result.zip
      @country  = result.country_code
      @lat      = result.lat
      @lng      = result.lng
      @status   = STATUS_GEOCODED
    else
      @status = STATUS_GEOCODE_ERROR
    end
  end
end
