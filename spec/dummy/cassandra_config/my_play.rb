class MyPlay < DBbench::Play::Base

  def prepare_cassandra_query(params)
    { :count => params["count"].to_i }
  end
end
