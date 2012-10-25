module DBbench
  module Play
    class Base

      attr_accessor :params, :model, :dbtype

      def initialize(params, model)
        @params = params
        @model = model
        @dbtype = db_type_from_class(model)
      end

      def sql_where
        query = []
        params.each do |key, value|
          query << "#{key}='#{value}'"
        end
        query.join(" AND ")
      end

      def cassandra_key
        params.delete("key")
      end

      def prepare_cassandra_query(params)
        # OVERWRITE THIS FOR MORE OPTIONS TO QUERY
      end

      def execute
        if dbtype == :ar
          # executing count so we can be sure the query is actually evaluated
          # since queries are normally lazy
          model.where(sql_where).count
        elsif dbtype == :cassandra
          key = cassandra_key
          query = prepare_cassandra_query(params)
          res = model.find(key, query)
        end
      end

      def db_type_from_class(model)
        if model.superclass.name.start_with?("ActiveRecord")
          :ar
        elsif model.superclass.name.start_with?("ActiveColumn")
          :cassandra
        end
      end

    end
  end
end
