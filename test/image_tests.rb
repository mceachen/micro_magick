require 'test_helper'
require 'tempfile'

module ImageTests
  def self.included spec_class
    spec_class.class_eval do

      let(:img) { MicroMagick::Convert.new('test/480x270.jpg') }

      let(:corrupt) { MicroMagick::Convert.new('test/corrupt.jpg') }

      # By using the block format, the tempfile will be closed and deleted:
      let(:outfile) { Tempfile.open(%w(out .jpg)) { |ea| ea.path } }

      it 'extracts image geometry correctly' do
        img.width.must_equal 270
        img.height.must_equal 480
        img.corrupt?.must_be_false
      end

      xit 'detects corrupt images properly' do
        corrupt.width.must_be_nil
        corrupt.height.must_be_nil
        corrupt.corrupt?.must_be_true
      end

      it 'resizes to cropped square' do
        img.resize('64x64')
        command = img.write(outfile)
        command.must_equal "#{MicroMagick.cmd_prefix}convert -size 64x64 test/480x270.jpg -resize 64x64 " + Shellwords.escape(outfile)
        File.exist?(outfile).must_be_true
        g = MicroMagick::Geometry.new(outfile)
        g.width.must_equal 64 * 270 / 480
        g.height.must_equal 64
      end

      it 'removes exif headers from .strip' do
        img.strip
        command = img.write(outfile)
        command.must_equal "#{MicroMagick.cmd_prefix}convert test/480x270.jpg +profile \\* " + Shellwords.escape(outfile)
        i = MicroMagick::Image.new('test/480x270.jpg')
        i['Profile-EXIF'].must_be_nil
      end

      it 'crops properly' do
        command = img.quality(85).square_crop('North').resize('128x128').write(outfile)
        command.must_equal "#{MicroMagick.cmd_prefix}convert test/480x270.jpg " +
          "-quality 85 -gravity North -crop 270x270\\+0\\+0\\! -resize 128x128 " +
          Shellwords.escape(outfile)
        File.exist?(outfile).must_be_true
        g = MicroMagick::Image.new(outfile)
        g.width.must_equal 128
        g.height.must_equal 128

        # make sure calling previous arguments don't leak into new calls:
        img.resize("64x64")
        command = img.write(outfile)
        command.must_equal "#{MicroMagick.cmd_prefix}convert -size 64x64 test/480x270.jpg -resize 64x64 " +
          Shellwords.escape(outfile)
      end

      it 'raises errors from invalid parameters' do
        img.boing
        proc { img.write(outfile) }.must_raise MicroMagick::ArgumentError
      end

      let(:enoent) { MicroMagick::Image.new('nonexistant-file.jpg') }

      it 'raises NoSuchFile when fetching attributes' do
        proc { enoent.width }.must_raise MicroMagick::NoSuchFile
      end

      it 'raises NoSuchFile from write' do
        proc { enoent.overwrite }.must_raise MicroMagick::NoSuchFile
      end

      it 'raises NoSuchFile from overwrite' do
        proc { enoent.overwrite }.must_raise MicroMagick::NoSuchFile
      end
    end
  end
end
