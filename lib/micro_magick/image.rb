require 'shellwords'
require 'yaml'

module MicroMagick
  class Image
    attr_reader :input_file

    def initialize(input_file)
      @input_file = input_file
      @input_options = []
      @output_options = []
    end

    # If you need to add an option that affects processing of input files,
    # you can use this method.
    def add_input_option(option_name, *args)
      (@input_options ||= []).push(option_name)
      args.each { |ea| @input_options.push(Shellwords.escape(ea.to_s)) }

      # Support call chaining:
      self
    end

    # Ignore the checksum embedded in the image.
    # Useful if the image is known to not be corrupted but has an invalid checksum;
    # some devices export such broken images.
    def ignore_checksum
      # Only PNG for now
      add_input_option("-define", "png:ignore-crc")
    end

    def width
      identify.width unless corrupt?
    end

    def height
      identify.height unless corrupt?
    end

    def corrupt?
      identify && @corrupt
    end

    # Strip the image of any profiles or comments.
    # Note that this re-encodes the image, so it should only be used when downsampling
    # (say, for a thumbnail)
    # (ImageMagick has the -strip command, but GraphicsMagick doesn't.
    # It turns out that ```+profile *``` does the same thing.)
    def strip
      add_output_option('+profile', '*')
    end

    # Crop to a square, using the specified gravity.
    def square_crop(gravity = 'Center')
      gravity(gravity) unless gravity.nil?
      d = [width, height].min
      crop("#{d}x#{d}+0+0!")
    end

    # For normal options, like -resize or -flip, you can call .resize("32x32") or .flip().
    # If you need to add an output option that starts with a '+', you can use this method.
    def add_output_option(option_name, *args)
      (@output_options ||= []).push(option_name)
      args.each { |ea| @output_options.push(Shellwords.escape(ea.to_s)) }

      # if we're a resize call, let's give the -size render hint to gm, but only when it's safe:
      # * we don't have input options yet,
      # * we're not cropping (because the -size will prevent the crop from working),
      # * and we have dimensions in the form of NNNxNNN
      if %w{-geometry -resize -sample -scale}.include?(option_name) &&
        @input_options.empty? &&
        !@output_options.include?('-crop')
        dimensions = args.first
        if dimensions.to_s =~ /\A(\d+x\d+)\z/
          @input_options.push('-size', dimensions)
        end
      end
      # Support call chaining:
      self
    end

    # Runs "convert"
    # See http://www.imagemagick.org/script/convert.php
    def write(output_file)
      MicroMagick.exec(command('convert', output_file))
    ensure
      @input_options.clear
      @output_options.clear
    end

    # Runs "mogrify"
    # See http://www.imagemagick.org/script/mogrify.php
    def overwrite
      MicroMagick.exec(command('mogrify'))
    ensure
      @input_options.clear
      @output_options.clear
    end

    private

    def method_missing(method, *args, &block)
      add_output_option("-#{method.to_s}", *args)
    end

    def command(command_name, output_file = nil)
      cmd = [command_name]
      cmd.push *@input_options
      cmd.push Shellwords.escape(@input_file)
      cmd.push *@output_options
      cmd.push(Shellwords.escape(output_file)) if output_file
      cmd
    end

    def identify
      @identify || begin
        cmd = ['identify', '-verbose', '-format', '%wx%h', Shellwords.escape(input_file)]
        @identify = IdentifyParser.new(MicroMagick.exec(cmd, true))
        @corrupt = false
      rescue CorruptImageError => e
        @identify = {}
        @corrupt = true
      end
      @identify
    end
  end

  # Aliases to support < v0.0.6
  Geometry = Convert = Image
end
