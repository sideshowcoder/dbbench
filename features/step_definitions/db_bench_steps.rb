Given /^DBbench is configured$/ do
  DBbench.load_configuration(File.expand_path("config", DUMMY_PATH))
end

Given /^I provide a replay file to replay$/ do
  DBbench.load_replay_file(File.expand_path("replay_one.csv", DUMMY_PATH))
end

When /^DBbech is called to generate a record$/ do
  @number_of_records = Something.count
  DBbench.generate(1)
end

When /^I replay a query$/ do
  @play_result = DBbench.replay
end

Then /^A record should be added to the database$/ do
  Something.count.should == @number_of_records+1
end

Then /^I should see results$/ do
  @play_result.should_not be_nil
end

