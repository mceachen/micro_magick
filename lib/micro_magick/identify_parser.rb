module MicroMagick
  class IdentifyParser

    DIMENSIONS_RE = /(\d+)x(\d+)/

    attr_reader :width, :height
    def initialize(stdout)
      if (m = stdout.match(DIMENSIONS_RE))
        @width, @height = m[1].to_i, m[2].to_i
      end
    end
  end
end
