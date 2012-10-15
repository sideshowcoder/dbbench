require "csv"

module DBbench
  module Generator

    class MissingDataFile < Exception; end

    class  Enumerated

      attr_reader :items, :keys

      def initialize(name, options={})
        file = data_file_for_name(name, options[:directory])
        data = CSV.read(file)
        # get the header as an array of symbols
        @keys = data.shift.map(&:to_sym)
        @items = data.map { |row| Hash[*@keys.zip(row).flatten] } 
      end

      def data
        @items[@items.length-1]
      end

      private
      def data_file_for_name(name, directory)
        directory = directory || "."
        if File.exist?("#{directory}/#{name}.csv")  
          "#{directory}/#{name}.csv"
        else
          raise MissingDataFile
        end
      end

    end
  end
end
