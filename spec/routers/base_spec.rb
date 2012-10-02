require "spec_helper"
require "db_bench/routers/base"

describe DBbench::Router::Base do

  before(:each) do
    TestRouter = Class.new(DBbench::Router::Base)
  end

  it "should register routes" do
    lambda do
      TestRouter.class_eval { match "int(:num)" => :int }
    end.should change(TestRouter.routes, :length).by(1)
  end

  it "should match params from fieldtypes"
  it "should route to first matching route"
  it "should throw UnknownRoute if there is no route"

end
