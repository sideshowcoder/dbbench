class SomethingGenerator < DBbench::Generator::Base

  include DBbench::Generator::BaseTypesLib
  enumerate :foo, { directory: File.expand_path("../data", File.dirname(__FILE__)) }

end
