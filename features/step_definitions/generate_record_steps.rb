Given /^DBbench is configured$/ do
  DBbench.load_configuration(File.expand_path("config", DUMMY_PATH))
end

When /^DBbech is called to generate a record$/ do
  DBbench.generate(1)
end

Then /^A record should be added to the database$/ do
    pending # express the regexp above with the code you wish you had
end

