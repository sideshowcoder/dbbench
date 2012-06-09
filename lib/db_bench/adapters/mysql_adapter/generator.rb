require_relative "generated_lift"

module DbBench
  module Mysql
  
    class Generator
      
      SQL_TYPE_TO_DATA_MAPPING = {
        :md5 => /^varchar\(40\)/,
        :id => /^int\(10\)/,
        :tinyint => /^tinyint(\((\d+)\))?\s?(unsigned)?/,
        :enum => /^enum\(('([^,]+)',?)+\)/,
        :date => "date",
        :time => "time",
        :smallint => /^smallint(\((\d+)\))?\s?(unsigned)?/,
        :int => /^int(\((\d+)\))?\s?(unsigned)?/ ,
        :decimal => "decimal",
        :datetime => "datetime",
        :double => "double",
        :varchar => /^varchar\((\d+)\)/
      }
      
      def generate
        # Generate the data table for a GeneratedLift like { fieldname => sqltype }
        column_data = GeneratedLift.columns_hash.inject({}) do |hash, (key, value)|  
          hash[key] = value.sql_type
          hash
        end
        p build_data column_data
        # GeneratedLift.create! build_data column_data
      end
      
      private 
        def build_data column_data
          column_data.inject({}) do |hash, (field,type)|
            Generator::SQL_TYPE_TO_DATA_MAPPING.map do |func,matcher|
              if (m = matcher.match type)
                if [:varchar, :md5].include? func
                  hash[field] = send func, *m[1]
                elsif [:int, :tinyint, :smallint].include? func
                  hash[field] = send func, *m[2..m.length]
                elsif [:enum].include? func
                  hash[field] = send func, type.split(",").map { |e| /'(.+)'/.match(e)[1] }
                end
                break
              end
            end
            hash
          end
        end
        
        def md5
          # Return a random hash
          Digest::MD5.hexdigest rand.to_s
        end
        
        def varchar chars
        end
        
        def tinyint limit, unsigned=false
        end
        
        def smallint limit, unsigned=false
        end
        
        def int limit, unsigned=false
        end
        
        def decimal digits, scale
        end
        
        def double
        end
        
        def date
        end
        
        def time
        end
        
        def datetime
        end
        
        def enum options
          # return a random element from the arguments array 
          options[rand(options.length)]
        end              
    end
    
  end
end
