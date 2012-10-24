module DBbench
  module Play
    class Base

      attr_accessor :params, :model

      def initialize(params, model)
        @params = params
        @model = model
      end

      def sql_where
        query = []
        params.each do |key, value|
          query << "#{key}='#{value}'"
        end
        query.join(" AND ")
      end

      def execute
        # executing count so we can be sure the query is actually evaluated
        # since queries are normally lazy
        model.where(sql_where).count
      end

    end
  end
end
