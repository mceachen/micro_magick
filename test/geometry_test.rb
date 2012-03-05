require "test/unit"
require "micro_magick"

class GeometryTest < Test::Unit::TestCase
  def test_geometry
    img = MicroMagick::Convert.new("test/480x270.jpg")
    assert_equal 270, img.width
    assert_equal 480, img.height
  end
end
