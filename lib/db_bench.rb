require "benchmark"
require "active_record"
require "active_support/inflector"

require "configuration/loader"
require "routers/base"
require "generators/base"
require "players/player"
require "players/play_base"

module DBbench
  class << self
    attr_reader :config, :player
  end

  def self.load_configuration(config_path)
    @config = Configuration.new(config_path)
  end

  def self.load_replay_file(replay_file_path)
    # FIXME should we asume for the main model to be the first one in the file?
    # this should at least be documented
    @player = Player.new(replay_file_path, @config.play, @config.models.first)
  end

  def self.replay(&block)
    player.run(&block)
  end

  def self.replay_benchmark(&block)
    result = Benchmark.measure do 
      player.run(&block)
    end
    "#{result.utime}, #{result.stime}, #{result.total}, #{result.real}"
  end

  def self.generate(count)
    config.generators.each do |g| 
      count.times { g.generate }
    end
  end
end
