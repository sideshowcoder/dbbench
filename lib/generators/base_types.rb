require "active_support/concern"

module DBbench
  module Generator
    module BaseTypesLib
      extend ActiveSupport::Concern

      included do
        # define max constants according to db
        MAX_INT = 2147483647
      end

      # create an integer between 0 and limit
      def int(limit, unsigned = false)
        if unsigned
          rand(MAX_INT*2) % (10**limit)
        else
          value = rand(MAX_INT) % (10**limit)
          rand(2) == 0 ? - value : value
        end
      end
    end
  end
end

