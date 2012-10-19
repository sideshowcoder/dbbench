module DBbench
  class Configuration

    attr_accessor :model_names, :dbconfig, :config_root
    attr_reader :play

    def initialize(config_path)
      @config_root = config_path
      # add root to loadpath so we can require rb files from it
      $:.unshift(@config_root)
      connect_to_database(config_file_path("database.yml"))
      load_models(config_file_path("dbbench.yml"))
      load_play(config_file_path("dbbench.yml"))
      load_generators_and_routers
    end

    def routers
      @model_names.map do |m| 
        "#{m}Router".constantize
      end
    end
    
    def generators
      @model_names.map do |m| 
        "#{m}Generator".constantize
      end
    end

    def models
      @model_names.map do |m|
        m.constantize
      end
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
      @model_names = YAML.load(File.read(config_file))["models"].map(&:camelize)
      @model_names.map(&:downcase).each { |f| require f }
    end
    
    def load_play(config_file)
      p = YAML.load(File.read(config_file))["play"]
      require p
      @play = p.camelize.constantize
    end

    def load_generators_and_routers
      @model_names.map(&:downcase).each do |m| 
        require "#{m}_generator"
        require "#{m}_router"
      end
    end

  end
end
