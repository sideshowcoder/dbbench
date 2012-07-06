require_relative "generated_lift"
require "geohash"

module DbBench
  module Mysql
  
    class Query
      
      # Use geo method
      GEOFUNC = :calculate_radius_with_geohash
      # GEOFUNC = :calculate_radius

      # Passes the query to the correct query function based on the type
      def query args
        GeneratedLift.where build_query_string GEOFUNC, args
      end
      
      private
        # prepare the argumenst by transforming values as needed
        def build_query_string geofunc, args
          # remove NULL Values
          query = args.delete_if { |key, val| val.to_s.match /NULL/ }
          query_conditions = []
          geofunc = self.method(geofunc)
          # Radius Search
          if destination_id = query["destination_id"].to_i
            # calculate the radius to search for destination_radius
            if (destination_radius = query["destination_radius"].to_i) && destination_radius != 0
              # get lat and long
              if (lift = GeneratedLift.find_by_destination_id destination_id)
                destination_lat = lift.destination_lat
                destination_long = lift.destination_long
              
                query.delete "destination_long"
                query.delete "destination_lat"
                query.delete "destination_radius"
              
                if destination_long.nil? || destination_lat.nil?
                  # No Long Lat for those so cant do radius search
                else
                  # Clear from query
                  query.delete "destination_id"                
                  # Add Condition
                  query_conditions << geofunc.call(destination_lat, destination_long, destination_radius, "destination")
                end
              end
            end
          end          
                    
          if departure_id = query["departure_id"].to_i
            # calculate the radius to search for destination_radius
            if (departure_radius = query["departure_radius"].to_i) && departure_radius != 0
              # get lat and long
              if (lift = GeneratedLift.find_by_departure_id departure_id)
                departure_lat = lift.departure_lat
                departure_long = lift.departure_long
                
                query.delete "departure_long"
                query.delete "departure_lat"
                query.delete "departure_radius"
                
                if departure_lat.nil? || departure_long.nil?
                   # No Long Lat for those so cant do radius search
                else      
                   # Clear from query
                   query.delete "departure_id"
                   # Add Condition
                   query_conditions << geofunc.call(departure_lat, departure_long, departure_radius, "departure")
                end
              end
            end
          end
          
          # Date Search
          if base_date = query["search_date"]
            query["date"] = base_date
            query.delete "search_date"
          end
          
          if search_date_range = query["search_date_range"]
            query.delete "search_date_range"
          end
          
          if search_date_range != 0 && base_date
            base_date = Date.parse base_date
            query_conditions << "(date BETWEEN ''#{base_date.to_s}' AND '#{(base_date + search_date_range.to_i).to_s}')" 
          end
          
          # Remaining query parameters
          if !query.empty?
            query_conditions << query.map { |key, val| val.class == String ? "#{key} = '#{val}'" : "#{key} = #{val}" }
          end
          
          query_conditions.join " AND "
        end
        
        def calculate_radius lat, long, radius, label
          lat1km = 1/111.0
          long1km = (1 / (Math::cos( deg2rad lat ) * 111)).abs

          "(#{label}_lat BETWEEN #{lat - (lat1km * radius)} AND #{lat + (lat1km * radius)}) AND
          (#{label}_long BETWEEN #{long - (long1km * radius)} AND #{long + (long1km * radius)}) AND
          (POW((abs(#{label}_lat - #{lat})/#{lat1km}),2))+(POW((abs(#{label}_long-#{long})/#{long1km}),2)) <= #{radius**2}"
        end
        
        def deg2rad th
          th / 180.0 * Math::PI
        end
        
        def calculate_radius_with_geohash lat, long, radius, label
          
          gh = GeoHash.encode lat, long, 8
          
          lat1km = 1/111.0
          long1km = (1 / (Math::cos( deg2rad lat ) * 111)).abs

          "(#{label}_geohash LIKE '#{gh}%') AND
          (POW((abs(#{label}_lat - #{lat})/#{lat1km}),2))+(POW((abs(#{label}_long-#{long})/#{long1km}),2)) <= #{radius**2}"
        end
        
  
    end
  
  end
end
