require "spec_helper"

describe DBbench::Configuration do

  before(:each) do
    DBbench.load_configuration(File.expand_path("dummy/config", SPEC_ROOT))
  end

  it "should load the generators and routers" do
    lambda { Something }.should_not raise_error
    lambda { SomethingGenerator }.should_not raise_error
    lambda { SomethingRouter }.should_not raise_error
  end

  it "should define generators, routers and models" do
    DBbench.config.models.should include "Something"
    DBbench.config.routers.should include "SomethingRouter"
    DBbench.config.generators.should include "SomethingGenerator"
  end

end
