require File.join(File.dirname(__FILE__), 'spec_helper')
require 'monad-do-notation'

describe DoNotation, "#run" do

  it "returns correct array" do
    array = DoNotation.run do
      get(:x) { 3.times }
      get(:y) { %w(a b) }
      just { ["#{x}#{y}"] }
    end

    array.should == %w(0a 0b 1a 1b 2a 2b)

  end

end