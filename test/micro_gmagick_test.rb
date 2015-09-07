require 'test_helper'
require 'image_tests'

describe 'Image tests under GraphicsMagick' do
  before { MicroMagick.use_graphicsmagick! }

  it 'properly reports using graphicsmagick' do
    MicroMagick.imagemagick?.must_equal false
    MicroMagick.graphicsmagick?.must_equal true
  end

  it 'returns the correct GraphicsMagick version' do
    # ImageMagick should be around 1.3.x-ish. See http://www.graphicsmagick.org/Changelog.html
    MicroMagick.version.must_be :<, Gem::Version.new('1.4')
    MicroMagick.version.must_be :>, Gem::Version.new('1.0')
  end

  include ImageTests
end

