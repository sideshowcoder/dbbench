require "spec_helper"

class APlay < DBbench::Play::Base; end
class AModel; end

describe DBbench::Play::Base do

  let(:play) do
    APlay.new({id: 1}, AModel)
  end

  it "should construct an sql string" do
    play.sql_where.should == "id='1'"
  end

  it "should run against the model passed" do
    ar = double("ActiveRecordRelation", :count => 1)
    AModel.stub(:where).with("id='1'").and_return(ar)
    play.execute.should == 1
  end

end
