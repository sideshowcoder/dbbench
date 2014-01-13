require "spec_helper"

class KickGenerator < DBbench::Generator::Base; end
class KickRouter < DBbench::Router::Base; end
class Kick; end

describe DBbench::Generator::Base do

  it "should should generate a hash with the given layout filled with data" do
    KickGenerator.stub(:groins).and_return(:kick)
    KickGenerator.layout = { kickme: "groins" }
    KickGenerator.router = double("Router", :route => { function: :groins, arguments: "" })
    KickGenerator.generate(true)[:kickme].should == :kick
  end

  it "should raise UnkownGeneratorError if the generator function is not defined" do
    KickGenerator.layout = { kickme: "shins" }
    KickGenerator.router = double("Router", :route => { function: :shins, arguments: ""})
    lambda { KickGenerator.generate }.should raise_error DBbench::Generator::UnkownGeneratorError
  end

  it "should raise an UnkownGeneratorError if the router does not find a function" do
    KickGenerator.layout = { kickme: "shins" }
    KickGenerator.router = double("Router", :route => { })
    lambda { KickGenerator.generate }.should raise_error DBbench::Generator::UnkownGeneratorError
  end

  describe "Enumerated Properties" do

    before(:each) do
      KickGenerator.tap do |klass|
        klass.enumerate :sample, directory: "#{SPEC_ROOT}/fixtures"
      end
    end

    it "should include the data from the enumerated properties" do
      KickGenerator.layout = { }
      KickGenerator.generate(true)[:id].should_not be_nil
    end

    it "should not overwrite the data from the enumerated properties" do
      KickGenerator.stub(:id).and_return(:thisshouldneverhappen)
      KickGenerator.layout = { id: "id" }
      KickGenerator.router = double("Router", :route => { function: :id, arguments: "" })
      KickGenerator.generate(true)[:id].should == "1"
    end

  end

  describe "Layout inference" do
    before(:each) do
      KickGenerator.layout = nil
    end

    it "should get the layout from the infered AR conform model if not set" do
      Kick.stub(:columns_hash).and_return({ foo: stub(:sql_type=> "bar")})
      KickGenerator.layout.should == { foo: "bar" }
    end

  end

  describe "Router inference" do
    before(:each) do
      KickGenerator.router = nil
    end

    it "should route the call based on the infered router" do
      router = stub(:route => {function: :nothing, arguments: ""})
      KickRouter.stub(:new).and_return(router)
      KickGenerator.stub(:nothing).and_return(:great)
      KickGenerator.layout = { nothing: "nothing" }
      KickGenerator.generate(true)[:nothing].should == :great
    end

  end


end
