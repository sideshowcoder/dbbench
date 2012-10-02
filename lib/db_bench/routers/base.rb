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

    class Base
      class << self
        attr :routes
      end

      def self.routes
        @routes ||= []
      end

      def self.match(route)
        routes << route
      end
    end

  end
end
