require "spec_helper"

describe "Player" do

  before(:each) do
    DBbench.load_configuration(File.expand_path("dummy/config", SPEC_ROOT))
    DBbench.load_replay_file(File.expand_path("dummy/replay_one.csv", SPEC_ROOT))
  end

  it "should load the plays" do
    DBbench.player.plays.length.should == 1
  end

end
