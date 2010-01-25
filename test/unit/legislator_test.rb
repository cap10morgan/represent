require 'test_helper'

class LegislatorTest < ActiveSupport::TestCase
  def setup
    @candidate_id  = '561'
    @first_name    = 'Diana'
    @last_name     = 'DeGette'
    @zip           = '80218'
    @plus4         = '2208'
    @leg = Legislator.new(:first_name => @first_name,
      :last_name => @last_name)
  end
  
  test "instantiation" do
    assert_instance_of Legislator, @leg, "Is not an instance of Legislator"
  end
  
  test "initial_values" do
    assert_equal @first_name, @leg.first_name, "Does not return correct first_name value"
    assert_equal @last_name, @leg.last_name, "Does not return correct last_name value"
  end
  
  test "can_find_all_legislators_in_zip" do
    legislators = Legislator.find_all_by_zip(@zip, @plus4)
    assert_equal 5, legislators[:federal].count + legislators[:state].count, "Did not return 5 legislators"
  end
  
  test "can_load_data_from_api" do
    legislators = Legislator.find_all_by_zip(@zip, @plus4)
    found_legislator = false
    legislators.each do |type,list|
      list.each do |leg|
        #puts "Checking #{leg.first_name} #{leg.last_name}"
        if leg.first_name == @first_name and leg.last_name == @last_name
          found_legislator = true
          leg.load_data!
          assert_equal @candidate_id, leg.candidate_id, "Did not retrieve (correct) legislator from API"
        end
      end
    end
    assert found_legislator, "Did not find legislator"
  end
end
