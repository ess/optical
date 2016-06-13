module Optical
  class Flag
    getter name : Symbol,
      short : String,
      long : String,
      argument : String?,
      value : String? | Bool?,
      on : Proc(Bool? | String?, Void)

    def initialize(@name)
      @short = ""
      @long = ""
      @on = Proc(Bool? | String?, Void).new {}
    end

    def short=(token)
      @short = token
    end

    def long=(token)
      @long = token
    end

    def argument=(token)
      @argument = token
    end

    def action(&block : (Bool? | String?) ->)
      @on = block
    end

    def matches?(token : String)
      token == short || token == long
    end

    def process(argv)
      argv.shift

      on.call(argument.nil? ? true : argv.shift)

      argv
    end
  end
end
