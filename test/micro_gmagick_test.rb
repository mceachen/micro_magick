require 'test_helper'
require 'image_tests'

describe 'Image tests under GraphicsMagick' do
  before { MicroMagick.use_graphicsmagick }
  include ImageTests
end

