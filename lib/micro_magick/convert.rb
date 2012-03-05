require 'shellwords'

module MicroMagick
  class Convert
    def initialize(input_file)
      @input_file = input_file
      @input_options = []
      @output_options = []
    end

    def width
      geometry.width
    end

    def height
      geometry.height
    end

    def geometry
      @geometry ||= MicroMagick::Geometry.new(@input_file)
    end

    # strip the image of any profiles or comments
    # (ImageMagick has the -strip command, but GraphicsMagick doesn't.
    # It turns out that ```+profile *``` does the same thing.)
    def strip
      add_output_option("+profile", "*")
    end

    # Crop to a square, using the specified gravity.
    def square_crop(gravity = "Center")
      gravity(gravity) unless gravity.nil?
      d = [width, height].min
      crop("#{d}x#{d}+0+0!")
    end

    # For normal options, like -resize or -flip, you can call .resize("32x32") or .flip().
    # If you need to add an output option that starts with a '+', you can use this method.
    def add_output_option(option_name, *args)
      (@output_options ||= []) << option_name
      @output_options += args.collect { |ea| Shellwords.escape(ea.to_s) }

      # if we're a resize call, let's give the -size render hint to gm, but only when it's safe:
      # * we don't have input options yet,
      # * we're not cropping (because the -size will prevent the crop from working),
      # * and we have dimensions in the form of NNNxNNN
      if %w{-geometry -resize -sample -scale}.include?(option_name) &&
        @input_options.empty? &&
        !@output_options.include?("-crop")
        if (dimensions = args.first)
          if dimensions =~ /^(\d+x\d+)$/
            @input_options << "-size #{dimensions}"
          end
        end
      end
    end


    # Executes `convert`, writing to output_file, and clearing all previously set input and output options.
    # @return the command given to system()
    def write(output_file)
      @output_file = output_file
      cmd = command()
      MicroMagick.exec(cmd)
      @input_options.clear
      @output_options.clear
      cmd
    end

    protected

    def method_missing(method, *args, &block)
      add_output_option("-#{method.to_s}", *args)
    end

    def command
      ([MicroMagick.cmd_prefix, "convert"] +
        @input_options +
        [Shellwords.escape(@input_file)] +
        @output_options +
        [Shellwords.escape(@output_file)]).compact.join(" ")
    end
  end
end
