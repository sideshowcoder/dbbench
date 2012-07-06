require "csv"
require "benchmark"


module DbBench
  # Supported Databases and their adapter type
  DATABASES = db_types_to_adapter_mapping = {
    mysql: "mysql"
  }
  
  # Load error if database adapter is not found
  class DBAdapterLoadError < LoadError
  end
  
  # Benchmark configuration
  class Config
    # Database
    attr_accessor :db_config
    attr_reader :dbtype
    
    # Output file
    attr_accessor :outfile
    
    # Input file
    attr_accessor :infile
    
    def initialize db_config, outfile=false, infile=false
      @db_config = db_config
      @outfile = outfile if outfile
      @infile = infile if infile
    end
            
    # Load the correct adapter based on the type passed 
    def dbtype= _dbtype
      @dbtype = _dbtype.to_sym
      if DbBench::DATABASES.include? @dbtype
        begin
          require "db_bench/adapters/#{DbBench::DATABASES[@dbtype]}"
        rescue LoadError => e
          puts e
          raise DbBench::DBAdapterLoadError, "Failed to load #{DbBench::DATABASES[_dbtype]}"
        end        
      else
        raise DbBench::DBAdapterLoadError, "Failed to load #{DbBench::DATABASES[_dbtype]}"        
      end
    end
    
  end
  
  # Basic Settings for Benchmark 
  class BenchmarkBase
    attr_accessor :db, :config
    
    def initialize config
      # Get the Database
      @db = eval("DbBench::#{DbBench::DATABASES[config.dbtype].capitalize}")
      @query = eval("DbBench::#{DbBench::DATABASES[config.dbtype].capitalize}::Query").new
      @generator = eval("DbBench::#{DbBench::DATABASES[config.dbtype].capitalize}::Generator").new
      @config = config
    end
    
    def connect
      @db.connect config.db_config
    end
    
  end
  
  # Generate Data for test
  class Generator < DbBench::BenchmarkBase
    def start data_sets
      connect
      data_sets.times do
        @generator.generate
        yield
      end
    end
  end
      
  # Run tests
  class Runner < DbBench::BenchmarkBase    
    def start
      # Connect the Database
      connect
      # Prepare writer
      CSV.open @config.outfile, "w+" do |wcsv|
        # Prepare reader
        CSV.foreach @config.infile, :headers => true do |input|
          
          # Run the Query and log time
          count = 0
          result = Benchmark.measure do
            count = @query.query input.to_hash
          end
          
          # Progress callback commmand finished
          yield
          
          # remove empty lable and preppend command
          result = result.to_a
          result.shift
          result = input.to_a.concat result
          result << count
          
          # write to file
          wcsv << result
          
        end
      
      end
    end
    
    
  end
    
end