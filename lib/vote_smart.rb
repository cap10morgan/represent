require 'uri'
require 'net/http'

class VoteSmart
  include Singleton
  
  attr_reader :api_key
  
  def initialize
    @config = YAML.load_file("#{RAILS_ROOT}/config/votesmart.yml")[RAILS_ENV]
    @api_key = @config[:api_key]
  end
  
  def make_request klass, method, args
    url = 'http://api.votesmart.org/'
    url += "#{klass.to_s}.#{method.to_s}?key=#{@api_key}&o=JSON"
    args = args.collect do |k,v|
      "#{k.to_s}=#{v.to_s}"
    end
    url += '&' + args.join('&')
    #puts "URL: #{url}"
    url = URI.parse(url)
    res = Net::HTTP.get(url)
    #puts "JSON: #{res}"
    obj = ActiveSupport::JSON.decode(res)
  end
  
  def find_all_officials_by_zip args
    res = make_request(:Officials, :getByZip, args)
    return [] unless res and res['candidateList']
    officials_raw = res['candidateList']['candidate']
    officials = Array.new
    officials_raw.each do |o|
      official = Hash.new
      o.each do |key,value|
        #puts "Adding #{key} => #{value} to official"
        official[key.underscore.to_sym] = value
      end
      officials << official
    end
    officials
  end
  
  def find_by_candidate_id candidate_id
    res = make_request(:CandidateBio, :getBio, {:candidateId => candidate_id})
    candidate_raw = res['bio']
    candidate = Hash.new
    candidate_raw.each do |section,hash|
      next if section == 'generalInfo'
      hash.each do |key,value|
        my_key = key.underscore
        my_key = "#{section.underscore}_#{my_key}" unless section == 'candidate'
        candidate[my_key.to_sym] = value
      end
    end
    candidate
  end
end