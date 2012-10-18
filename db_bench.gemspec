# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "db_bench/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Philipp Fehre"]
  gem.email         = ["phil@cospired.com"]
  gem.description   = %q{Database benchmark tools to create input data and rerun defined queries}
  gem.summary       = %q{Tools to benchmark a database}
  gem.homepage      = "https://github.com/sideshowcoder/dbbench"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "db_bench"
  gem.require_paths = ["lib"]
  gem.version       = DBbench::VERSION
  
  #gem.add_dependency "thor"
  #gem.add_dependency "progressbar"  
  #gem.add_dependency "ffaker"
  gem.add_dependency "mysql2"
  gem.add_dependency "activerecord"  
  gem.add_dependency "activesupport"  
  #gem.add_dependency "activesupport"
  #gem.add_dependency "active_column"
  #gem.add_dependency "geohash", ">= 1.1.2"
  # testing and development
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec_candy"
  gem.add_development_dependency "cucumber"

end
