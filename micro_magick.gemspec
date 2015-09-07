# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'micro_magick/version'

Gem::Specification.new do |s|
  s.name        = 'micro_magick'
  s.version     = MicroMagick::VERSION
  s.authors     = ['Matthew McEachen']
  s.email       = %w(matthew-github@mceachen.org)
  s.homepage    = 'https://github.com/mceachen/micro_magick'
  s.summary     = 'Simple and efficient ImageMagick/GraphicsMagick ruby wrapper'
  s.description = ''
  s.license = 'MIT'

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = %w(lib)

  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-great_expectations'
  s.add_development_dependency 'minitest-reporters' unless ENV['CI']
end
