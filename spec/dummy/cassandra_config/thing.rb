class Thing < ActiveColumn::Base

  key :thing_id
  attr_accessor :thing_id, :data

  def self.create!(*args)
    self.new(*args).save
  end
end
