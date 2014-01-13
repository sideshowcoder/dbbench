require "spec_helper"

class TestRouter < DBbench::Router::Base
  match "^int\\((.+)\\)$" => :int
end

describe DBbench::Router::Base do


  let(:testrouter) { TestRouter.new }

  it "should register routes" do
    TestRouter.routes.length.should == 1
  end

  it "should match params from fieldtypes" do
    match = TestRouter.routes[0][:matcher]
    testrouter.params_for_matcher("int(9)", match).should == ["9"]
  end

  it "should route to first matching route" do
    testrouter.route("int(9)").should == { function: :int, arguments: ["9"] }
  end

  it "should throw UnknownRoute if there is no route" do
    lambda { testrouter.route("faz") }.should raise_error DBbench::Router::UnknownRoute
  end

end
