require 'test_helper'
require 'image_tests'

describe 'Image tests under ImageMagick' do
  before { MicroMagick.use_imagemagick! }

  it 'properly reports using imagemagick' do
    MicroMagick.imagemagick?.must_equal true
    MicroMagick.graphicsmagick?.must_equal false
  end

  it 'returns the correct ImageMagick version' do
    # ImageMagick should be around 6.9.x-ish. See http://www.imagemagick.org/script/changelog.php
    puts MicroMagick.version
    MicroMagick.version.must_be :<, Gem::Version.new('7.0.0')
    MicroMagick.version.must_be :>, Gem::Version.new('6.3.0')
  end

  include ImageTests
end

