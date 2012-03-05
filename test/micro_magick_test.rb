require "test/unit"
require "micro_magick"

class MicroMagickTest < Test::Unit::TestCase

  def test_use_nil
    # This shouldn't throw:
    MicroMagick.use(nil)

    # eh, ok, now we should stub out system
    # and verify that the next call to cmd_prefix
    # calls `hash gm`?

    # Meh, let's just assume that the test running machine has gm in their PATH.
    assert_equal MicroMagick.cmd_prefix, "gm"
  end

  def test_use_invalid
    assert_raise MicroMagick::InvalidArgument do
      MicroMagick.use(:boink)
    end
  end

  def test_use_gm
    MicroMagick.use(:graphicsmagick)
    assert_equal "gm", MicroMagick.cmd_prefix
  end

  def test_use_im
    MicroMagick.use(:imagemagick)
    assert_equal nil, MicroMagick.cmd_prefix
  end

end
