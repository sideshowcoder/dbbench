module DBbench
  
  class << self
    attr_reader :config
  end

  def self.load_configuration(config_path)
    @config = Configuration.new(config_path)
  end

  class Configuration

    attr_accessor :models, :generators, :routers, :dbconfig, :config_root

    def initialize(config_path)
      @config_root = config_path
      # add root to loadpath so we can require rb files from it
      $:.unshift(@config_root)
      connect_to_database(config_file_path("database.yml"))
      load_models(config_file_path("dbbench.yml"))
      load_generators_and_routers
    end

    def routers
      @routers ||= @models.map { |m| "#{m}Router" }
    end
    
    def generators
      @generators ||= @models.map { |m| "#{m}Generator" }
    end

    private
    def config_file_path(filename, config_root = @config_root)
      File.expand_path(filename, config_root)
    end

    def connect_to_database(config_file)
      db = YAML.load(File.read(config_file))
      ActiveRecord::Base.establish_connection(db)
    end

    def load_models(config_file)
      @models = YAML.load(File.read(config_file))["models"].map(&:camelize)
      @models.map(&:downcase).each { |f| require f }
    end

    def load_generators_and_routers
      @models.map(&:downcase).each do |m| 
        require "#{m}_generator"
        require "#{m}_router"
      end
    end

  end
end
