require "db_bench"
require "thor"
require "progressbar"

class DbBench::CLI < Thor

  desc "benchmark [COMMANDFILE] [RESULTFILE] [DATABACONFIGFILE] [DATABASETYPE]", "Benchmark a Database with given commands"
  def benchmark infile, outfile, db_config, type
    config = DbBench::Config.new db_config, outfile, infile
    begin
      config.dbtype = type
    rescue DbBench::DBAdapterLoadError => e
      error "Database adapter for #{type} could not be loaded"
    end

    ok "Loaded Configuration"
    
    begin
      runner = DbBench::Runner.new config
    
      # Get the progressbar
      pbar = ProgressBar.new "Benchmark", File.open(infile).readlines.size 
    
      runner.start do 
        pbar.inc
      end
    
      pbar.finish
      ok "Benchmark successfull"

    rescue Exception => e
      error "Failed with Error #{e}"
    end
  end
  
  desc "generate [DATABACONFIGFILE] [DATABASETYPE]", "Generate the Date for a given Database Schema"
  def generate db_config, type, data_sets=100000
    data_sets = data_sets.to_i
    config = DbBench::Config.new db_config
    begin
      config.dbtype = type
    rescue DbBench::DBAdapterLoadError => e
      error "Database adapter for #{type} could not be loaded"
    end

    ok "Loaded Configuration"
    
    begin
      generator = DbBench::Generator.new config
    
      # Get the progressbar
      pbar = ProgressBar.new "Generate Data", data_sets
    
      generator.start(data_sets) { pbar.inc }
    
      pbar.finish
      ok "Data generation successfull"

    rescue Exception => e
      error "Failed with Error #{e}"
    end    
  end

private 

  def em(text)
    shell.set_color(text, nil, true)
  end

  def ok(detail=nil)
    text = detail ? "OK, #{detail}." : "OK."
    say text, :green
  end

  def error(detail)
    say detail, :red
  end


end