Given /^DBbench is configured$/ do
  DBbench.load_configuration(File.expand_path("config", DUMMY_PATH))
end

Given /^DBbench is configured for cassandra$/ do
  DBbench.load_configuration(File.expand_path("cassandra_config", DUMMY_PATH))
end

Given /^I provide a replay file$/ do
  DBbench.load_replay_file(File.expand_path("replay_one.csv", DUMMY_PATH))
end

Given /^I provide a replay file for cassandra$/ do
  DBbench.load_replay_file(File.expand_path("replay_one_cassandra.csv", DUMMY_PATH))
end

When /^DBbench is called to generate a record$/ do
  @number_of_records = Something.count
  DBbench.generate(1)
end

When /^I replay$/ do
  @result = DBbench.replay
end

When /^I replay given a block$/ do
  @result = []
  DBbench.replay { |r| @result << r }
end

When /^DBbench is called to generate a record in cassandra$/ do
  # we generate with an id of "1234"
  begin 
    @number_of_records = Thing.find("1234").fetch("1234").length
  rescue KeyError
    @number_of_records = 0
  end
  DBbench.generate(1)
end

Then /^A record should be added to the database$/ do
  Something.count.should == @number_of_records+1
end

Then /^I should see results$/ do
  @result.first.should_not be_nil
end

Then /^the record should be found$/ do
  Thing.find("1234").fetch("1234").length.should == @number_of_records+1
end

