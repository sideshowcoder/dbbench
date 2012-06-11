require_relative "generated_lift"
require "ffaker"

module DbBench
  module Mysql
  
    class Generator
      
      SQL_TYPE_TO_DATA_MAPPING = {
        :md5 => /^varchar\(40\)/,
        :tinyint => /^tinyint(\((\d+)\))?\s?(unsigned)?/,
        :enum => /^enum\(('([^,]+)',?)+\)/,
        :date => /^date/,
        :time => /^time/,
        :smallint => /^smallint(\((\d+)\))?\s?(unsigned)?/,
        :int => /^int(\((\d+)\))?\s?(unsigned)?/ ,
        :decimal => /^decimal\((\d+),(\d+)\)/,
        :datetime => /^datetime/,
        :double => /^double/,
        :varchar => /^varchar\((\d+)\)/
      }
      
      def generate
        # Generate the data table for a GeneratedLift like { fieldname => sqltype }
        column_data = GeneratedLift.columns_hash.inject({}) do |hash, (key, value)|  
          hash[key] = value.sql_type
          hash
        end
        GeneratedLift.create! build_data column_data
      end
      
      private 
        def build_data column_data
          column_data.inject({}) do |hash, (field,type)|
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
                elsif [:double, :date, :time, :datetime].include? func
                  hash[field] = send func
                else
                  p m
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
        
        def double
          rand(100000000000000010901051724930857196452234783424494612613028642816) + rand
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
