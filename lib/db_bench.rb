require "active_record"
require "active_support/inflector"

require "configuration/loader"
require "routers/base"
require "generators/base"

module DBbench
  class << self
    attr_reader :config
  end

  def self.load_configuration(config_path)
    @config = Configuration.new(config_path)
  end

  def self.generate(count)
    @config.generators.each do |g| 
      count.times { g.generate }
    end
  end
end
