# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "micro_magick/version"

Gem::Specification.new do |s|
  s.name        = "micro_magick"
  s.version     = MicroMagick::VERSION
  s.authors     = ["Matthew McEachen"]
  s.email       = ["matthew-github@mceachen.org"]
  s.homepage    = "https://github.com/mceachen/micro_magick"
  s.summary     = %q{Simplest ImageMagick/GraphicsMagick ruby wrapper EVAR}
  s.description = %q{Simplest ImageMagick/GraphicsMagick ruby wrapper EVAR}

  s.rubyforge_project = "micro_magick"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
end
