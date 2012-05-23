require "db_bench"
require "thor"
require "progressbar"

class DbBench::CLI < Thor

  desc "benchmark [COMMANDFILE] [RESULTFILE] [DATABASECONNECTIONSTRING] [DATABASETYPE]", "Benchmark a Database with given commands"
  def benchmark infile, outfile, connect_string, type
    config = DbBench::Config.new infile, outfile, connect_string
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