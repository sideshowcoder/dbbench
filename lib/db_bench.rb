require "benchmark"
require "active_record"
require "cassandra/1.1"
require "active_column"
require "active_support/inflector"

require "configuration/loader"
require "routers/base"
require "generators/base"
require "players/player"
require "players/play_base"

module DBbench
  class << self
    attr_reader :config, :player, :generators
  end

  def self.load_configuration(config_path)
    @config = Configuration.new(config_path)
    @generators = @config.generators
  end

  def self.load_replay_file(replay_file_path)
    # FIXME should we asume for the main model to be the first one in the file?
    # this should at least be documented
    @player = Player.new(replay_file_path, @config.play, @config.models.first)
  end

  def self.replay(&block)
    player.plays.map do |play|
      m = Benchmark.measure { play.execute }
      am = "#{m.utime}, #{m.stime}, #{m.total}, #{m.real}"
      yield am if block_given?
      am
    end
  end

  def self.generate(count)
    generators.each do |g|
      count.times { g.generate }
    end
  end


end
