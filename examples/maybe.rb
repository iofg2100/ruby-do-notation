$:.unshift File.dirname(__FILE__) + '/../lib'
require 'monad-do-notation'

class Maybe

  attr_reader :value

  def initialize(x = nil)
    @value = x
  end

  def flat_map(&f)
    Maybe.new(if @value then f.call(@value).value end)
  end
  
end

def divide(x, y)
  if y == 0
    Maybe.new
  else
    Maybe.new(x / y)
  end
end

def divide_print(x, y)

  puts "Dividing #{x} by #{y}..."

  divide = DoNotation.run do
    get(:x) { Maybe.new(x) }
    get(:y) { Maybe.new(y) }
    just { divide(x, y) }
  end

  if divide.value
    puts "Succeeded! Result = #{divide.value}"
  else
    puts "Failed!"
  end

end

divide_print(10, 2)
divide_print(10, 0)
