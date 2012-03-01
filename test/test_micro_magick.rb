require "test/unit"
require "shellwords"
require "micro_magick"

class TestMicroMagick < Test::Unit::TestCase

  def test_use
    MicroMagick.use(:graphicsmagick)
    assert_equal MicroMagick.cmd_prefix, "gm"
    MicroMagick.use(:imagemagick)
    assert_equal MicroMagick.cmd_prefix, nil

    # This shouldn't throw:
    MicroMagick.use(nil)
    # eh, ok, now we should stub out system
    # and verify that the next call to cmd_prefix
    # calls `hash gm`?

    # Meh, let's just assume that the test running machine has gm in their PATH.
    assert_equal MicroMagick.cmd_prefix, "gm"

    assert_raise MicroMagick::InvalidArgument do
      MicroMagick.use(:boink)
    end
  end

  def test_convert
    i = MicroMagick::Convert.new("test/640.jpg")
    i.strip
    i.quality(85)
    i.gravity("Center")
    i.crop("250x250")
    i.resize("128x128")
    outfile = mktmpfile
    assert !File.exist?(outfile)
    i.write(outfile)
    assert_equal i.command, "gm convert -size 128x128 test/640.jpg +profile \\* " +
      "-quality 85 -gravity Center -crop 250x250 -resize 128x128 " +
      Shellwords.escape(outfile)
    assert File.exist?(outfile)
  end

  def mktmpfile
    tmp = Tempfile.new('out.jpg')
    outfile = tmp.path
    tmp.close
    tmp.delete
    outfile
  end

  def test_bad_args
    i = MicroMagick::Convert.new("test/640.jpg")
    i.boing
    assert_raise MicroMagick::InvalidArgument do
      i.write(mktmpfile)
    end
  end
end

