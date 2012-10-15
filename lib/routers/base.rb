# DBbench router
#
# Create a router to match the field type of a database to a given function
# to generate data
#
# class KickRouter < DBbench::Router::Base
#   match "int(:id)" => :int
# end
#
  
module DBbench
  module Router

    class UnknownRoute < StandardError; end

    class Base
      class << self
        attr_accessor :routes
      end

      def self.routes
        @routes ||= []
      end

      def self.match(route)
        route = { matcher: Regexp.new(route.keys[0]), function: route.values[0] }
        routes << route
      end
      
      def route(field)
        self.class.routes.each do |r|
          if r[:matcher].match(field)
            return { 
              function: r[:function], 
              arguments: params_for_matcher(field, r[:matcher])
            }
          end
        end
        raise UnknownRoute
      end

      def params_for_matcher(field, definition)
        matched = definition.match(field)
        matched.to_a[1..-1]
      end
    end

  end
end
