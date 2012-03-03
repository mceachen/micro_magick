require "test/micro_magick_test_base"

class MicroGmagickTest < MicroMagickTestBase

  def setup
    MicroMagick.use(:graphicsmagick)
    super
  end

end

