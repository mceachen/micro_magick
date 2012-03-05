require "./test/micro_magick_test_base"

class MicroImagickTest < MicroMagickTestBase

  def setup
    MicroMagick.use(:imagemagick)
    super
  end

end

