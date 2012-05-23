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
  
  attr_accessor :db
  
  def initialize db
    @db = db
  end
  
  def query args
    # FIXME do something usefull with args
    res = db.query("SELECT * FROM product WHERE id = #{args[0].to_i}")
  end
  
end