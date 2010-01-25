class LegislatorsController < ApplicationController

  def index
    find
  end

  def find
    if params[:zip]
      return zip
    end
    respond_to do |format|
      format.html { render :action => "find" }
    end
  end
  
  def zip
    @zip = params[:zip]
    @zip ||= params[:id]
    zip5, plus4 = @zip.split('-')
    plus4 ||= '0000'
    #puts "Calling find_all_by_zip(#{zip5}, #{plus4})"
    @legislators = Legislator.find_all_by_zip(zip5, plus4)
    if @legislators[:federal].count == 0 and @legislators[:state].count == 0
      flash.now[:notice] = "No legislators found for #{@zip}"
      respond_to do |format|
        format.html { render :action => "find" }
      end
      return
    end
    respond_to do |format|
      format.html { render :action => "zip" }
      #format.xml  { render :xml => @legislators }
      #format.json { render :json => @legislators }
    end
  end

  # GET /legislators/1
  # GET /legislators/1.xml
  def show
    @leg = Legislator.find(params[:id])

    respond_to do |format|
      format.html { render :action => "show" }
      format.xml  { render :xml => @leg }
    end
  end
end
