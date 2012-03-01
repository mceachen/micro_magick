require 'shellwords'

module MicroMagick
  class Convert
    def initialize(input_file)
      @args = [Shellwords.escape(input_file)]
    end

    def command
      ([MicroMagick.cmd_prefix, "convert", @pre_input] + @args).compact.join(" ")
    end

    def write(output_file)
      @args << Shellwords.escape(output_file)
      MicroMagick.exec command
    end

    def method_missing(method, *args, &block)
      if @pre_input.nil? && [:geometry, :resize, :sample, :scale].include?(method)
        dimensions = args.first
        # let's give the -size render hint to gm, but only if we're a resize call, and we have simple dimensions:
        if dimensions && (simple_dim = dimensions.scan(/(\d+x\d+)/).first)
          @pre_input = "-size #{simple_dim}"
        end
      end

      if method == :strip
        # ImageMagick knows that ```-strip```, means ```+profile "*"```
        @args << '+profile'
        @args << Shellwords.escape('*')
      else
        @args << "-#{method.to_s}"
      end
      @args += args.compact.collect { |ea| Shellwords.escape(ea.to_s) }
    end
  end
end
