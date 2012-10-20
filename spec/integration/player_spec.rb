require "spec_helper"

describe "Player" do

  before(:each) do
    DBbench.load_configuration(File.expand_path("dummy/config", SPEC_ROOT))
    DBbench.load_replay_file(File.expand_path("dummy/replay_one.csv", SPEC_ROOT))
  end

  it "should load the plays" do
    DBbench.player.plays.length.should == 1
  end

  it "should run a play and return the result" do
    ar = double("ActiveRecordSomething", :count => true)
    Something.stub(:where).with("data='foo'").and_return(ar)
    DBbench.player.run do
      |left| left.should == 0 
    end.should be_true
  end

end
