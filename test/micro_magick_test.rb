require 'test_helper'

describe MicroMagick do

  it 'uses GraphicsMagick by default' do
    # Assume that the machine that's running the test has gm in it's PATH
    MicroMagick.reset!
    MicroMagick.cmd_prefix.must_equal 'gm '
  end

  it 'uses GraphicsMagick when set explicitly' do
    MicroMagick.use_graphicsmagick
    MicroMagick.cmd_prefix.must_equal 'gm '
  end

  it 'uses ImageMagick when set explicitly' do
    MicroMagick.use_imagemagick
    MicroMagick.cmd_prefix.must_equal ''
  end

end
