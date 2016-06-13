require "./flag"

module Optical
  class Parser
    getter flags : Array(Flag)

    def initialize
      @flags = [] of Flag
    end

    def flag(name : Symbol, &block : Flag ->)
      f = Flag.new(name)
      block.call(f)
      flags.push(f)
    end

    def order(argv)
      until argv.empty?
        processor = flags.find {|flag| flag.matches?(argv.first)}
        break if processor.nil?

        argv = processor.process(argv)
      end

      argv
    end
  end
end
