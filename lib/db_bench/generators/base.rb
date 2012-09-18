require "db_bench/generators/enumerated"

module DBbench
  module Generator
    class UnkownGeneratorError < Exception; end

    class Base

      class << self
        attr_accessor :layout
        attr_accessor :matcher
        attr_accessor :enumerators
      end

      def self.enumerate(name, options={}) 
        self.enumerators ||= Array.new
        self.enumerators << Enumerated.new(name, options)
      end

      def self.generate
        basic_types.merge(enumerated_types)
      end

      protected
      def self.basic_types
        self.layout.inject({}) do |hash, (fieldname, fieldtype)|
          generator = self.matcher.generator(fieldtype)
          begin
            hash[fieldname] = self.send(generator.fetch(:function), 
                                        generator.fetch(:arguments))
          rescue NoMethodError
            raise UnkownGeneratorError, "#{generator.fetch(:function)} was \
              used for data generation but is not defined"
          rescue KeyError
            raise UnkownGeneratorError, "no generator found for #{fieldtype}"
          end
          hash
        end
      end

      def self.enumerated_types 
        unless self.enumerators.nil?
          self.enumerators.inject({}) do |hash, enumerator|
            hash.merge!(enumerator.data)
          end
        else
          {}
        end
      end

    end
  end
end
