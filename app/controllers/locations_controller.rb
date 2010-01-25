class LocationsController < ApplicationController

  def index
    address_form
  end
  
  def address_form
    if params[:addr1]
      return show
    end
    respond_to do |format|
      format.html { render :action => 'address_form' }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.new(:street => params[:addr1]+", "+params[:addr2],
      :city => params[:city], :state => params[:state], :zip => params[:zip])

    @location.geocode!

    respond_to do |format|
      format.html { redirect_to "/legislators/zip/#{@location.zip}" }
      format.xml  { render :xml => @location }
    end
  end
end
