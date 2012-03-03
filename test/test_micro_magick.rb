require "test/unit"
require "shellwords"
require "micro_magick"

class TestMicroMagick < Test::Unit::TestCase

  def test_use
    MicroMagick.use(:graphicsmagick)
    assert_equal "gm", MicroMagick.cmd_prefix
    MicroMagick.use(:imagemagick)
    assert_equal nil, MicroMagick.cmd_prefix

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

  def test_geometry
    i = MicroMagick::Convert.new("test/480x270.jpg")
    assert_equal 270, i.width
    assert_equal 480, i.height
  end

  def test_resize
    i = MicroMagick::Convert.new("test/480x270.jpg")
    i.resize("64x64")
    tmp = mktmpfile
    command = i.write(tmp)
    assert_equal "gm convert -size 64x64 test/480x270.jpg -resize 64x64 " + Shellwords.escape(tmp), command
    assert File.exist?(tmp)
    g = MicroMagick::Geometry.new(tmp)
    assert_equal (64 * (270.0/480.0)).to_i, g.width
    assert_equal 64, g.height
  end

  def test_convert_with_crop
    i = MicroMagick::Convert.new("test/480x270.jpg")
    i.strip
    i.quality(85)
    i.gravity("Center")
    i.square_crop
    i.resize("128x128")
    tmp = mktmpfile
    command = i.write(tmp)
    assert_equal "gm convert test/480x270.jpg +profile \\* " +
        "-quality 85 -gravity Center -crop 270x270\\+0\\+0\\! -resize 128x128 " +
        Shellwords.escape(tmp),
      command
    assert File.exist?(tmp)
    g = MicroMagick::Geometry.new(tmp)
    assert_equal 128, g.width
    assert_equal 128, g.height

    # make sure calling previous arguments don't leak into new calls:
    i.resize("64x64")
    command = i.write(tmp)
    assert_equal "gm convert -size 64x64 test/480x270.jpg -resize 64x64 " +
        Shellwords.escape(tmp),
      command
  end

  def mktmpfile
    tmp = Tempfile.new('out.jpg')
    outfile = tmp.path
    tmp.close
    tmp.delete
    assert !File.exist?(outfile)
    outfile
  end

  def test_bad_args
    i = MicroMagick::Convert.new("test/480x270.jpg")
    i.boing
    assert_raise MicroMagick::InvalidArgument do
      i.write(mktmpfile)
    end
  end
end

