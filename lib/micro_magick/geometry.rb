require 'shellwords'

module MicroMagick
  class Geometry
    attr_reader :width, :height

    def initialize(input_file)
      cmd = [MicroMagick.cmd_prefix,
        "identify",
        "-format",
        "%w:%h",
        Shellwords.escape(input_file)
      ]
      geometry = MicroMagick.exec(cmd.join(" "))
      @width, @height = geometry.split(':').collect { |ea| ea.to_i }
    end

    def to_s
      "#{width} x #{height}"
    end
  end
end
