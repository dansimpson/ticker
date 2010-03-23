#ticker

* a simple gem for gathering and streaming stock data

##Installation

If you don't have gemcutter

	gem install gemcutter
	gem tumble

Otherwise

	gem install ticker

Or

	gem install ticker -s http://gemcutter.org


##Docs

See RDoc

##Quick Example

	require 'rubygems'
	require 'ticker'

	quote = Ticker::Quote.new("GOOG")
	quote.update
	
	#print all data
	quote.print
	
	#print specific things
	p quote.ask
	p quote.bid
	
	
	#only gather a few things
	quote = Ticker::Quote.new("GOOG", :only => [:ask, :bid, :pe_ratio, :ask_size])
	quote.update
	
	# print Ask, Bid, P/E Ratio, and Ask Size
	quote.print