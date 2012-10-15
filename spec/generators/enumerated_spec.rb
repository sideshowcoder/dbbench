require "spec_helper"

describe DBbench::Generator::Enumerated do
  subject do
    DBbench::Generator::Enumerated.new(:sample, { directory: "#{SPEC_ROOT}/fixtures" })
  end

  it "should throw an error if the data file is not present" do
    lambda do
      DBbench::Generator::Enumerated.new(:nothere) 
    end.should raise_error(DBbench::Generator::MissingDataFile) 
  end
 
  it "should read a csv" do
    subject.items[0].should include_hash(id: "1", name: "pants", price: "1.99")
  end

  it "should return an entry" do
    subject.data.should include_hash(id: "1")
  end

  it "should list the keys" do
    subject.keys.should == [:id, :name, :price]
  end

end

