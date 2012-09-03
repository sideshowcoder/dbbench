# -*- encoding: utf-8 -*-
require File.expand_path('../lib/db_bench/version', __FILE__)

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
  gem.version       = DbBench::VERSION
  
  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "progressbar"  
  gem.add_runtime_dependency "ffaker"
  gem.add_runtime_dependency "mysql2"
  gem.add_runtime_dependency "activerecord"  
  gem.add_runtime_dependency "active_column"
  gem.add_runtime_dependency "geohash", ">= 1.1.2"
  # testing and development
  gem.add_development_dependency "activesupport"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec_candy"

end
