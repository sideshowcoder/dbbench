require "spec_helper"
require "db_bench/generators/base_types"

class BaseTypesTest
  include DBbench::Generator::BaseTypesLib
end

describe DBbench::Generator::BaseTypesLib do

  subject do
    BaseTypesTest.new
  end
  
  describe "int generator" do
    it "should create signed integers" do
      subject.int(2).should be_between(-99, 99)
    end

    it "should create usigned integers" do 
      subject.int(2, true).should be_between(0, 99)
    end
  end

end

