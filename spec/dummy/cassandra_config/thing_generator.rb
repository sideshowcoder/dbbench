class ThingGenerator < DBbench::Generator::Base

  self.layout = {
    thing_id: "uuid",
    data: "varchar(100)"
  }

  include DBbench::Generator::BaseTypesLib
  enumerate :data, { directory: File.expand_path("../data", File.dirname(__FILE__)) }

  def self.fake_uuid
    "1234"
  end

end
