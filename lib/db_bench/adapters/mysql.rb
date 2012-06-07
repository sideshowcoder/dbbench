require "active_record"
require "yaml"
require_relative "mysql_adapter/generator"
require_relative "mysql_adapter/query"

module DbBench
  module Mysql
    # Establish Database connection to use
    def Mysql.connect dbconfig_file
      dbconfig = YAML::load(File.open(dbconfig_file))
      ActiveRecord::Base.establish_connection(dbconfig)
    end
  end
end
