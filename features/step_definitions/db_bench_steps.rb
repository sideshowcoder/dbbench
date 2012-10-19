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

When /^I benchmark a query$/ do
  @benchmark_result = DBbench.run_replay_benchmark
end

When /^I benchmark the whole replay file$/ do
  @benchmark_all = DBbench.replay_benchmark(:all)
end

Then /^A record should be added to the database$/ do
  Something.count.should == @number_of_records+1
end

Then /^I should see results$/ do
  @play_result.should_not be_nil
end

Then /^I should get the benchmark results$/ do
  @benchmark_result.should match /^\d+.\d+,( \d+.\d+,){2} \d+.\d+$/
end

Then /^I should get the benchmark results for the replay$/ do
  @benchmark_all.first.should match /^\d+.\d+,( \d+.\d+,){2} \d+.\d+$/
end
