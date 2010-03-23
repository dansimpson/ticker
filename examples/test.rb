$:.unshift File.dirname(__FILE__) + "/../lib"

require "rubygems"
require "ticker"

quote = Ticker::Quote.new("AAPL")
quote.update
quote.print

p "--------------------"

quote = Ticker::Quote.new("GOOG", :only => [:ask, :bid])
quote.update
quote.print

p "--------------------"