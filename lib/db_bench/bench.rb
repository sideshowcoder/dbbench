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
    attr_accessor :connect_string
    attr_reader :dbtype
    
    # Output file
    attr_accessor :outfile
    
    # Input file
    attr_accessor :infile
    
    def initialize infile, outfile, connect_string
      @connect_string = connect_string
      @outfile = outfile
      @infile = infile
    end
            
    # Load the correct adapter based on the type passed 
    def dbtype= _dbtype
      @dbtype = _dbtype.to_sym
      if DbBench::DATABASES.include? @dbtype
        begin
          require "db_bench/adapters/#{DbBench::DATABASES[@dbtype]}"
        rescue LoadError => e
          raise DbBench::DBAdapterLoadError, "Failed to load #{@@db_types_to_adapter_mapping[_dbtype]}"
        end        
      else
        raise DbBench::DBAdapterLoadError, "Failed to load _dbtype"        
      end
    end
    
  end
      
  class Runner
    attr_accessor :db, :config
    
    def initialize config
      # Get the Database
      @db = Kernel.const_get(DbBench::DATABASES[config.dbtype].capitalize)
      @config = config
    end
    
    def start
      # Connect the Database
      db.connect @config.connect_string do |conn|
        # Prepare writer
        CSV.open @config.outfile, "w+" do |wcsv|
          # Prepare reader
          CSV.foreach @config.infile, :headers => true do |input|
            # default query is search
            type = :search
            type = input["qtype"].to_sym if input["qtype"]
            
            # Run describe on the query and log rows touched
            rows_touched = conn.query_describe type, input.to_hash
                        
            # Run the Query and log time
            result = Benchmark.measure do
              conn.query type, input.to_hash
            end
            
            # Progress callback commmand finished
            yield
            
            # remove empty lable and preppend command
            result = result.to_a
            result.shift
            result.push rows_touched
            result = input.to_a.concat result
            
            # write to file
            wcsv << result
            
          end

        end
      end
    end
    
    
  end
    
end