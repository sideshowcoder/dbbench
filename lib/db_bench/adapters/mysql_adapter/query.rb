require_relative "generated_lift"

module DbBench
  module Mysql
  
    class Query

      # Passes the query to the correct query function based on the type
      def query args
        GeneratedLift.where build_query_string args
      end
      
      private
        # prepare the argumenst by transforming values as needed
        def build_query_string args
          # remove NULL Values
          query = args.delete_if { |key, val| val.to_s.match /NULL/ }
          query.map do |key, val|
            val.class == String ? "#{key} = '#{val}'" : "#{key} = #{val}"
          end.join " AND " 
        end
  
    end
  
  end
end
