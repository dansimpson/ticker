spec = Gem::Specification.new do |s|
	s.name = 'ticker'
	s.version = '0.1'
	s.date = '2010-03-07'
	s.summary = 'Quick and easy stock quote tool'
	s.email = "dan.simpson@gmail.com"
	s.homepage = "http://github.com/dansimpson/ticker"
	s.description = "A simple financial data tool for gathering and streaming stock data"
	s.has_rdoc = true

	s.authors = ["Dan Simpson"]

	s.files = [
		"README.markdown",
		"ticker.gemspec",
		"examples/test.rb",
		"lib/ticker.rb",
		"lib/ticker/quote.rb"
	]
end
