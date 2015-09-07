require 'minitest/autorun'
require 'minitest/great_expectations'
require 'micro_magick'

unless ENV['CI']
  require 'minitest/reporters'
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]
end