require_relative "generated_lift"
require_relative "../../random_modules/city_map"
require "ffaker"
require "geohash"


module DbBench
  module Mysql
  
    class Generator
      
      SQL_TYPE_TO_DATA_MAPPING = {
        :dbid => /^int\(10\)/,
        :md5 => /^varchar\(40\)/,
        :tinyint => /^tinyint(\((\d+)\))?\s?(unsigned)?/,
        :enum => /^enum\(('([^,]+)',?)+\)/,
        :date => /^date/,
        :time => /^time/,
        :smallint => /^smallint(\((\d+)\))?\s?(unsigned)?/,
        :int => /^int(\((\d+)\))?\s?(unsigned)?/ ,
        :decimal => /^decimal\((\d+),(\d+)\)/,
        :datetime => /^datetime/,
        :varchar => /^varchar\((\d+)\)/
      }
      
      def generate
        # Generate the data table for a GeneratedLift like { fieldname => sqltype }
        column_data = GeneratedLift.columns_hash.inject({}) do |hash, (key, value)|  
          hash[key] = value.sql_type
          hash
        end
        data = build_data column_data
        #  generate the geohash
        data["departure_geohash"] = GeoHash.encode(data["departure_lat"], data["departure_long"])
        data["destination_geohash"] = GeoHash.encode(data["destination_lat"], data["destination_long"])
        GeneratedLift.create! data
      end
      
      private 
        def build_data column_data
          column_data.inject({}) do |hash, (field,type)|
            # Don't generate data for long, lat and matching ids
            unless ["departure_lat", "departure_long", "departure_id", "destination_lat", "destination_long", "destination_id"].include? field
              Generator::SQL_TYPE_TO_DATA_MAPPING.map do |func,matcher|
                if (m = matcher.match type)
                  if [:varchar, :md5].include? func
                    hash[field] = send func, *m[1]
                  elsif [:decimal].include? func
                    hash[field] = send func, *m[1..2]
                  elsif [:int, :tinyint, :smallint].include? func
                    hash[field] = send func, *m[2..m.length]
                  elsif [:enum].include? func
                    hash[field] = send func, type.split(",").map { |e| /'(.+)'/.match(e)[1] }
                  elsif [:date, :time, :datetime, :dbid].include? func
                    hash[field] = send func
                  else
                    # The value is supposed to be nil! because it catches all the errors
                    hash[field] = nil
                  end
                  break
                end
              end
            end
            # Inject random geo taken from the city map
            hash.merge! CityMap.instance.random_city("departure")
            hash.merge! CityMap.instance.random_city("destination")
            hash
          end
        end
        
        def dbid
          int 10, true
        end
        
        def md5
          # Return a random hash
          Digest::MD5.hexdigest rand.to_s
        end
        
        def varchar chars
          Faker::Lorem.words(30).join[0..chars.to_i]
        end
        
        def tinyint limit, unsigned=false
          int limit, unsigned, 127 
        end
        
        def smallint limit, unsigned=false
          int limit, unsigned, 32768 
        end
        
        def int limit, unsigned=false, max_signed=2147483647
          limit = limit.to_i() -1
          max_unsigned = max_signed*2
          if unsigned
            val = rand max_unsigned
          else
            val = rand(2) == 0 ? rand(max_signed) : -(rand max_signed)        
          end
          val.to_s[0..limit].to_i
        end
        
        def decimal digits, scale
          scale = scale.to_i
          digits = digits.to_i() - scale
          rand.to_s[0..scale].to_f() + int(digits)
        end
                
        def date
          Date.new
        end
        
        def time
          Time.now
        end
        
        def datetime
          DateTime.now
        end
        
        def enum options
          # return a random element from the arguments array 
          options[rand(options.length)]
        end              
    end
    
  end
end
