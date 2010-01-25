class Legislator
  attr_reader :candidate_id, :title, :first_name, :last_name, :middle_name,
   :nick_name, :suffix, :photo, :office_parties, :office_district_name,
   :office_state_id
  
  def initialize attrs=nil
    set_instance_variables! attrs if attrs
    @data_loaded = false
  end
  
  def id
    @candidate_id
  end
  
  def photo
    load_data!
    @photo
  end
  
  def pretty_district_name
    district_name = office_district_name
    if district_name =~ /^\d+$/
      district_name.to_i.ordinalize
    else
      district_name
    end
  end
  
  def self.find id
    Legislator.new(:candidate_id => id).load_data!
  end
  
  def self.find_all_by_zip zip5, plus4
    vs = VoteSmart.instance
    officials = vs.find_all_officials_by_zip(:zip5 => zip5, :zip4 => plus4)
    legislators = {:federal => Array.new, :state => Array.new}
    officials.each do |off|
      if off[:office_type_id] == 'C'
        legislators[:federal] << Legislator.new(off)
      elsif off[:office_type_id] == 'L'
        legislators[:state] << Legislator.new(off)
      end
    end
    legislators
  end
  
  # may not actually need this method if I don't implement DB caching
  def load_data!
    unless @data_loaded
      vs = VoteSmart.instance
      attrs = vs.find_by_candidate_id(candidate_id)
      set_instance_variables! attrs
      @data_loaded = true
    end
    self
  end
  
  private
  
  def set_instance_variables! attrs
    attrs.each do |key,value|
      if respond_to? key
        #puts "Setting #{key} to #{value}"
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
