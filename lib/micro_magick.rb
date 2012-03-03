require "micro_magick/version"
require "micro_magick/convert"
require "micro_magick/geometry"
require "tempfile"

module MicroMagick

  InvalidArgument = Class.new(StandardError)

  ENGINE2PREFIX = { :imagemagick => nil, :graphicsmagick => "gm" }

  # @param engine must be :imagemagick, :graphicsmagick, or nil (which means reset to default behavior,
  # which means the next run will determine if GraphicsMagick or ImageMagick is installed)
  def self.use(engine)
    unless engine.nil? || ENGINE2PREFIX.keys.include?(engine)
      raise InvalidArgument, "Unknown graphics engine #{engine}"
    end
    @engine = engine
  end

  def self.cmd_prefix
    @engine ||= begin
      if system("hash gm 2>&-")
        :graphicsmagick
      elsif system("hash convert 2>&-")
        :imagemagick
      else
        raise InvalidArgument, "Please install either GraphicsMagick or ImageMagick"
      end
    end
    ENGINE2PREFIX[@engine]
  end

  def self.exec(cmd)
    stderr_file = Tempfile.new('stderr')
    stderr_path = stderr_file.path
    stderr_file.close
    result = `#{cmd} 2>"#{stderr_path}"`
    stderr = File.read(stderr_path).strip
    stderr_file.delete
    if $?.exitstatus != 0 || !stderr.empty?
      raise InvalidArgument, "#{cmd} failed: #{stderr}"
    end
    result
  end

end


