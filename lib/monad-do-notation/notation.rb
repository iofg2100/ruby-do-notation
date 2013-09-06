
module DoNotation

  class DSL

    def initialize(result, &block)

      @first_lets = []
      @proc_sources = []
      @variables = Hash[]

      # evaluate DSL
      instance_eval(&block)

      bind = lambda do |head_source, tail_sources, get_symbol, lets|

        proc do |x|

          if get_symbol
            @variables[get_symbol] = x
          end

          lets.each do |let_item|
            @variables[let_item.symbol] = instance_eval(&let_item.block)
          end

          monad = instance_eval(&head_source.block)

          if tail_sources.length > 0
            inner_proc = bind.call(tail_sources.first, tail_sources[1..-1], head_source.symbol, head_source.lets)
            monad.flat_map(&inner_proc)
          else
            monad
          end

        end

      end

      result << bind.call(@proc_sources.first, @proc_sources[1..-1], nil, @first_lets).call

    end

    def get(symbol, &block)
      if symbol
        self.class.send(:define_method, symbol) { @variables[symbol] }
      end
      @proc_sources << Struct.new(:symbol, :block, :lets).new(symbol, block, [])
    end

    def just(&block)
      self.get(nil, &block)
    end

    def let(symbol, &block)
      self.class.send(:define_method, symbol) { @variables[symbol] }
      item = Struct.new(:symbol, :block).new(symbol, block)
      if @proc_sources.length > 0
        @proc_sources.last.lets << item
      else
        @first_lets << item
      end
    end

  end

  def self.run(&block)
    result = []
    DSL.new(result, &block)
    result.first
  end

end