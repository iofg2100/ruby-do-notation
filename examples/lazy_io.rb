$:.unshift File.dirname(__FILE__) + '/../lib'
require 'monad-do-notation'

def getLine
  Enumerator.new { |y|
    y << gets
  }.lazy
end

def putStrLn(str)
  Enumerator.new { |y|
    puts str
    y << nil
  }.lazy
end

# this notation
main = DoNotation.run {
  just { putStrLn "Enter something" }
  get(:line) { getLine }
  let(:output) { "You said #{line}" }
  just { putStrLn output }
  just {  }
}

# is same as
=begin
main = putStrLn("Enter something").flat_map do
  getLine.flat_map do |line|
    output = "You said #{line}"
    putStrLn output
  end
end
=end

puts "Starting..."
main.force
