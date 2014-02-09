require 'test_helper'
require 'image_tests'

describe 'Image tests under ImageMagick' do
  before { MicroMagick.use_imagemagick }
  include ImageTests
end

