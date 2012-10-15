require "db_bench/generators/enumerated"
require "active_support/inflector"

module DBbench
  module Generator
    class UnkownGeneratorError < StandardError; end

    class Base

      def self.router
        if defined?(@router) && !@router.nil?
          @router
        else
          @router = self.infered_router
        end
      end

      def self.router=(router)
        @router = router
      end

      def self.layout
        if defined?(@layout) && !@layout.nil?
          @layout
        else
          @layout = self.infered_layout
        end
      end

      def self.layout=(layout)
        @layout = layout
      end

      def self.enumerate(name, options={}) 
        @enumerators ||= Array.new
        @enumerators << Enumerated.new(name, options)
      end

      def self.generate
        basic_types.merge(enumerated_types)
      end

      protected
      def self.infered_base_name
        self.to_s.split(/(?=[A-Z])/)[0...-1].join.constantize
      end

      def self.infered_router
        router_klass = "#{self.infered_base_name}Router".constantize
        router_klass.new
      end

      def self.infered_layout
        self.infered_base_name.columns_hash.inject({}) do |hash, (key, value)|
          hash[key] = value.sql_value
          hash
        end
      end

      def self.basic_types
        self.layout.inject({}) do |hash, (fieldname, fieldtype)|
          route = self.router.route(fieldtype)
          begin
            hash[fieldname] = self.send(route.fetch(:function), 
                                        route.fetch(:arguments))
          rescue NoMethodError
            raise UnkownGeneratorError, "#{route.fetch(:function)} was \
              used for data generation but is not defined"
          rescue KeyError
            raise UnkownGeneratorError, "no generator found for #{fieldtype}"
          end
          hash
        end
      end

      def self.enumerated_types 
        if defined?(@enumerators) && !@enumerators.nil?
          @enumerators.inject({}) do |hash, enumerator|
            hash.merge!(enumerator.data)
          end
        else
          {}
        end
      end

    end
  end
end
