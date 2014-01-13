require "active_support/concern"

module DBbench
  module Generator
    module BaseTypesLib
      extend ActiveSupport::Concern
      MAX_INT = 2147483647

      included do
        # define max constants according to db
      end

      module ClassMethods
        # create an integer between 0 and limit
        def int(limit, unsigned = false)
          limit = limit.to_i
          if unsigned
            rand(MAX_INT*2) % (10**limit)
          else
            value = rand(MAX_INT) % (10**limit)
            rand(2) == 0 ? - value : value
          end
        end

        def varchar(length) 
          length = length.to_i
          s = SecureRandom.urlsafe_base64(length)
          # for some reason SecureRandom does not return strings shorter
          # than 14 ... so we need to cut it sometimes
          if s.length > length
            s[0...length]
          else 
            s
          end
        end

        def uuid
          SecureRandom.uuid
        end

      end
    end
  end
end

