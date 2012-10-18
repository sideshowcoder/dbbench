Given /^DBbench is configured$/ do
  DBbench.load_configuration(File.expand_path("config", DUMMY_PATH))
end

When /^DBbech is called to generate a record$/ do
  @number_of_records = Something.count
  DBbench.generate(1)
end

Then /^A record should be added to the database$/ do
  Something.count.should == @number_of_records+1
end

