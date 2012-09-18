require "csv"

class CityMap
    
  include Singleton
      
  def initialize
    csv_data = CSV.read "#{File.expand_path(File.dirname(__FILE__))}/cities.csv"
    headers = csv_data.shift.map {|i| i.to_s }
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    @cities = string_data.map {|row| Hash[*headers.zip(row).flatten] }
  end
  
  def random_city label
    city = {}
    ccity = @cities[rand(@cities.length)]
    city["#{label}_id"] = ccity["id"].to_i
    city["#{label}_long"] = (ccity["dd_long"].to_f.round(2) + (rand / 100)).round(4)
    city["#{label}_lat"] = (ccity["dd_lat"].to_f.round(2) + (rand / 100)).round(4)
    city
  end
  
end