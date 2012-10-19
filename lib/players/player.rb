module DBbench

  class Player
    attr_accessor :plays

    def initialize(replay_file, play_klass, main_model)
      @plays = []
      CSV.read(replay_file, headers: true).each do |row|
        @plays << play_klass.new(row.to_hash, main_model)
      end
    end

    def run(&block)
      current = plays.pop || return
      yield plays.length if block_given?
      current.execute
    end

  end
end
