# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "timeedit/version"

Gem::Specification.new do |s|
  s.name        = "timeedit"
  s.version     = TimeEdit::VERSION
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "timeedit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock", ">= 1.8.0"
  
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "charlock_holmes"
end
