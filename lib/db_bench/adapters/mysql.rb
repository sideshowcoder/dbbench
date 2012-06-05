require "mysql"

class Mysql
  # Connection String user:password@host:port/database
  def self.connect connect_string
    
    # Parse the connection String
    cdata = connect_string.match /(\S+):(\S+)@(\S+):(\d+)\/(\S+)/
    user, pass, host, port, database = cdata[1], cdata[2], cdata[3], cdata[4], cdata[5]
    begin
      db = Mysql.real_connect(host, user, pass, database, port.to_i)
      connection = MysqlConncetionProxy.new db
      yield connection
    rescue Mysql::Error => e
      puts "Error code: #{e.errno}"
      puts "Error message: #{e.error}"
      puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
    ensure
      # disconnect from server
      db.close if db
    end    
  end
    
end

class MysqlConncetionProxy
  
  attr_accessor :db, :table
  
  def initialize db, table = "generated_lifts"
    @db = db
    @table = table
  end
  
  # Passes the query to the correct query function based on the type
  def query qtype, args
    case qtype
    when :search
      search_query args
    end
  end
  
  def query_describe qtype, args
    case qtype
    when :search
      search_query_describe args
    end
  end
  
  def search_query_describe args
    query_string = prepare_query_arguments args
    if not query_string.empty?    
      describe = db.query "DESCRIBE SELECT * FROM #{@table} WHERE #{query_string}"
      number_of_rows = 0
      describe.each_hash { |row| number_of_rows += row["rows"].to_i }
      number_of_rows
    end
  end
  
  # args is a hash key(field_name) => value(field_query_value) pairs
  def search_query args
    query_string = prepare_query_arguments args
    db.query "SELECT * FROM #{@table} WHERE #{query_string}" unless query_string.empty?
  end
  
  private
    # prepare the argumenst by transforming values as needed
    def prepare_query_arguments args
      # remove NULL Values
      query = args.delete_if { |key, val| val.to_s.match /NULL/ }
      query.map do |key, val|
        val.class == String ? "#{key} = '#{val}'" : "#{key} = #{val}"
      end.join " AND " 
    end
        
end