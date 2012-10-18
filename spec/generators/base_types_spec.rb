require "spec_helper"

class BaseTypesTest
  include DBbench::Generator::BaseTypesLib
end

describe DBbench::Generator::BaseTypesLib do

  subject do
    BaseTypesTest
  end
  
  describe "int generator" do
    it "should create signed integers" do
      subject.int(2).should be_between(-99, 99)
    end

    it "should create usigned integers" do 
      subject.int(2, true).should be_between(0, 99)
    end

    it "should work with strings passed" do
      subject.int("2").should be_kind_of Fixnum
    end
  end

  describe "varchar generator" do
    let(:string) { subject.varchar(10) }
    it "should generate a string" do
      string.should be_kind_of String
      string.length.should_not > 10
    end

    it "should sanatize the input" do
      lambda { subject.varchar("10") }.should_not raise_error
    end
  end

end

