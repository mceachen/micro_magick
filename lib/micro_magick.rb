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

  def self.use_imagemagick
    @cmd_prefix = ''
  end

  def self.use_graphicsmagick
    @cmd_prefix = 'gm '
  end

  def self.reset!
    @cmd_prefix = nil
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
    stdout = Open3.popen3(final_cmd) do |stdin, stdout, stderr|
      err = stderr.read.strip
      if err.size > 0
        error = if err =~ /unrecognized option/i
          ArgumentError
        elsif err =~ /corrupt/i
          CorruptImageError
        elsif err =~ /no such file or directory|unable to open/i
          NoSuchFile
        else
          Error
        end
        raise error, "#{final_cmd} failed: #{err}"
      end
      stdout.read.strip
    end
    return_stdout ? stdout : final_cmd
  rescue Errno::ENOENT => e
    raise NoSuchFile, e.message
  end
end


