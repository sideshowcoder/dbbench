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

  def self.replay_benchmark(count = 1, &block)
    results = []
    if count == :all
      results << run_replay_benchmark do |left| 
        if left < 0
          return results     
        else
          yield left if block_given?
        end
      end
    else
      count.times do |n|
        results << run_replay_benchmark
        yield cound-n if block_given?
      end
    end
  end

  def self.generate(count)
    config.generators.each do |g| 
      count.times { g.generate }
    end
  end

  def self.run_replay_benchmark(&block)
    result = Benchmark.measure { player.run(&block) }
    "#{result.utime}, #{result.stime}, #{result.total}, #{result.real}"
  end

end
