require "spec_helper"
require "pry"
require "db_bench/generators/base"

#class SampleGenerator < DBbench::Generator::Base
  #enumerate :sample 
#end
  
class KickGenerator < DBbench::Generator::Base
end

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

    it "should define a Enumerated Generator for a property" do
      KickGenerator.enumerators.length.should == 1
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

end
