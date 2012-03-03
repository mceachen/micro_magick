require "test/unit"
require "shellwords"
require "micro_magick"

class MicroMagickTestBase < Test::Unit::TestCase

  def setup
    @img = MicroMagick::Convert.new("test/480x270.jpg")
    tmp = Tempfile.new('out.jpg')
    @outfile = tmp.path
    tmp.close
    tmp.delete
    assert !File.exist?(@outfile)
  end

  def cmd_prefix
    s = MicroMagick.cmd_prefix
    s.nil? ? "" : s + " "
  end

  def test_resize
    @img.resize("64x64")
    command = @img.write(@outfile)
    assert_equal "#{cmd_prefix}convert -size 64x64 test/480x270.jpg -resize 64x64 " + Shellwords.escape(@outfile), command
    assert File.exist?(@outfile)
    g = MicroMagick::Geometry.new(@outfile)
    assert_equal (64 * (270.0/480.0)).to_i, g.width
    assert_equal 64, g.height
  end

  def test_strip
    @img.strip
    command = @img.write(@outfile)
    assert_equal "#{cmd_prefix}convert test/480x270.jpg +profile \\* " + Shellwords.escape(@outfile), command
  end

  def test_convert_with_crop
    @img.quality(85)
    @img.square_crop("North")
    @img.resize("128x128")
    command = @img.write(@outfile)
    assert_equal "#{cmd_prefix}convert test/480x270.jpg " +
      "-quality 85 -gravity North -crop 270x270\\+0\\+0\\! -resize 128x128 " +
      Shellwords.escape(@outfile),
      command
    assert File.exist?(@outfile)
    g = MicroMagick::Geometry.new(@outfile)
    assert_equal 128, g.width
    assert_equal 128, g.height

    # make sure calling previous arguments don't leak into new calls:
    @img.resize("64x64")
    command = @img.write(@outfile)
    assert_equal "#{cmd_prefix}convert -size 64x64 test/480x270.jpg -resize 64x64 " +
      Shellwords.escape(@outfile),
      command
  end

  def test_bad_args
    @img.boing
    assert_raise MicroMagick::InvalidArgument do
      @img.write(@outfile)
    end
  end
end

