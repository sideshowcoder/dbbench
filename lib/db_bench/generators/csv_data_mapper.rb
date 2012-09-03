require "csv"

class CSVDataMapper

  attr_reader :items

  def initialize(file, types = {})
    data = CSV.read(file)
    # get the header as an array of symbols
    header = data.shift.map(&:to_sym)
    @items = data.map { |row| Hash[*header.zip(row).flatten] } 
  end

  def random
    @items[@items.length]
  end

end
