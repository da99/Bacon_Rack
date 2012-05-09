# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "Bacon_Rack/version"

Gem::Specification.new do |s|
  s.name        = "Bacon_Rack"
  s.version     = Bacon_Rack_Version
  s.authors     = ["da99"]
  s.email       = ["i-hate-spam-45671204@mailinator.com"]
  s.homepage    = "https://github.com/da99/Bacon_Rack"
  s.summary     = %q{Helper methods for Bacon specs that use rack-test.}
  s.description = %q{

    Provides helpers for your Bacon specs using rack-test:
    :renders, :redirects_to, :renders_assets.

    Read more at the homepage.

  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'bacon'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'Bacon_Colored'
  s.add_development_dependency 'pry'
  
  # Specify any dependencies here; for example:
  # s.add_runtime_dependency 'rest-client'
end
