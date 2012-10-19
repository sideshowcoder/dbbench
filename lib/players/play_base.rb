module DBbench
  module Play
    class Base

      attr_accessor :params, :model

      def initialize(params, model)
        @params = params
        @model = model
      end

      def sql_where
        where_string = ""
        params.each do |key, value|
          where_string << "#{key}='#{value}'"
        end
        where_string
      end

      def execute
        model.where(sql_where).count
      end

    end
  end
end
