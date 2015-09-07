require 'micro_magick/version'
require 'micro_magick/identify_parser'
require 'micro_magick/image'
require 'open3'

module MicroMagick

  Error = Class.new(StandardError)
  NoSuchFile = Class.new(Error)
  MissingBinaries = Class.new(Error)
  ArgumentError = Class.new(Error)
  CorruptImageError = Class.new(Error)

  def self.use_imagemagick!
    reset!
    @cmd_prefix = ''
  end

  def self.use_graphicsmagick!
    reset!
    @cmd_prefix = 'gm '
  end

  def self.graphicsmagick?
    cmd_prefix == 'gm '
  end

  def self.imagemagick?
    !graphicsmagick?
  end

  def self.reset!
    @cmd_prefix = @verbose_version = @version = nil
  end

  def self.verbose_version
    @verbose_version ||= begin
      cmd = graphicsmagick? ? %w(version) : %w(identify --version)
      exec(cmd, true)
    end
  end

  def self.version
    @version ||= begin
      m = verbose_version.split($/, 1).first.match(/([\d\.]{5,})/)
      Gem::Version.new(m[1]) if m
    end
  end

  def self.cmd_prefix
    @cmd_prefix ||= begin
      if system('hash gm 2>&-')
        'gm '
      elsif system('hash convert 2>&-')
        ''
      else
        raise MissingBinaries, 'Please install either GraphicsMagick or ImageMagick'
      end
    end
  end

  def self.exec(cmds, return_stdout = false)
    final_cmd = cmd_prefix + cmds.join(' ')
    stdout, stderr, status = Open3.capture3(final_cmd)
    err = stderr.strip
    if err.size > 0 || status != 0
      error = if err =~ /unrecognized option/i
                ArgumentError
              elsif err =~ /corrupt/i
                CorruptImageError
              elsif err =~ /no such file or directory|unable to open/i
                NoSuchFile
              else
                Error
              end
      raise error, "#{final_cmd} failed (#{status}): #{err}"
    end
    return_stdout ? stdout.strip : final_cmd
  rescue Errno::ENOENT => e
    raise NoSuchFile, e.message
  end
end


