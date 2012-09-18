require "spec_helper"
require "db_bench/generators/base"
  
class KickGenerator < DBbench::Generator::Base
end

class Kick; end

describe DBbench::Generator::Base do
  
  it "should should generate a hash with the given layout filled with data" do
    KickGenerator.stub(:groins).and_return(:kick)
    KickGenerator.layout = { kickme: "groins" }
    KickGenerator.matcher = double("Matcher", :generator => { function: :groins, arguments: "" })
    KickGenerator.generate[:kickme].should == :kick
  end

  it "should raise UnkownGeneratorError if the generator function is not defined" do
    KickGenerator.layout = { kickme: "shins" }
    KickGenerator.matcher = double("Matcher", :generator => { function: :shins, arguments: ""})
    lambda { KickGenerator.generate }.should raise_error DBbench::Generator::UnkownGeneratorError
  end

  it "should raise an UnkownGeneratorError if the matcher does not find a function" do
    KickGenerator.layout = { kickme: "shins" }
    KickGenerator.matcher = double("Matcher", :generator => { })
    lambda { KickGenerator.generate }.should raise_error DBbench::Generator::UnkownGeneratorError
  end

  describe "Enumerated Properties" do

    before(:each) do
      KickGenerator.tap do |klass|
        klass.enumerate :sample, directory: "#{DBbench::SPEC_ROOT}/fixtures"
      end
    end

    it "should include the data from the enumerated properties" do
      KickGenerator.layout = { }
      KickGenerator.generate[:id].should_not be_nil
    end

    it "should not overwrite the data from the enumerated properties" do
      KickGenerator.stub(:id).and_return(:thisshouldneverhappen)
      KickGenerator.layout = { id: "id" }
      KickGenerator.matcher = double("Matcher", :generator => { function: :id, arguments: "" })
      KickGenerator.generate[:id].should == "1"
    end

  end

  describe "Layout inference" do
    before(:each) do
      KickGenerator.layout = nil
    end

    it "should get the layout from the infered AR conform model if not set" do
      Kick.stub(:columns_hash).and_return({ foo: stub(:sql_value => "bar")})
      KickGenerator.layout.should == { foo: "bar" }
    end

  end

end
