module MicroMagick
  class IdentifyParser

    attr_reader :results

    def initialize(stdout)
      cleaned = stdout.encode('UTF-8', 'binary', :invalid => :replace, :undef => :replace, :replace => '')
      @lines = cleaned.split("\n").select { |ea| ea =~ /\S+:/ }
      if @lines.empty?
        @results = {}
      else
        @results = parse[:image] # < remove the "image" prefix.
        if (m = /(\d+)x(\d+)/.match(@results[:geometry]))
          @results[:width], @results[:height] = m[1].to_i, m[2].to_i
        end
      end
    end

    def [](key)
      results[key_to_sym(key)]
    end

    def parse
      result = {}
      while true
        line = @lines.shift
        key, value = split(line)
        if @lines.first && indent(line) < indent(@lines.first)
          # The current line has a sub-section.
          result[key] = parse()
        else
          result[key] = value
        end

        # Next line is indented less than the current line:
        break if @lines.first.nil? || indent(line) > indent(@lines.first)
      end
      result
    end

    def indent(line)
      /\S/.match(line).begin(0)
    end

    def split(line)
      k, v = line.split(':', 2).map(&:strip)
      [key_to_sym(k), v]
    end

    def key_to_sym(key)
      key.is_a?(Symbol) ? key : key.strip.gsub(/[\b\W_-]+/, '_').downcase.to_sym
    end
  end
end
