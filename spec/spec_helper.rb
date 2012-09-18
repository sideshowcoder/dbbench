require "bundler"
Bundler.setup
require "active_support/core_ext"
require "rspec"
require "rspec_candy/all"

module DBbench
  SPEC_ROOT = File.expand_path(File.dirname(__FILE__))
end


