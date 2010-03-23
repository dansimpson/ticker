# Author:: Dan Simpson
# Copyright:: Copyright (c) 2010 Dan Simpson
# License:: Distributes under the same terms as Ruby


module Ticker

    # A representation of a stock quote
    class Quote

        # available tags or bits of information for a
        # given stock
        @@tag_titles = {
            :a  => "Ask",
            :a2 => "Average Daily Volume",
            :a5 => "Ask Size",
            :b  => "Bid",
            :b2 => "Ask (Real-time)",
            :b3 => "Bid (Real-time)",
            :b4 => "Book Value",
            :b6 => "Bid Size",
            :c  => "Change & Percent Change",
            :c1 => "Change",
            :c3 => "Commission",
            :c6 => "Change (Real-time)",
            :c8 => "After Hours Change (Real-time)",
            :d  => "Dividend/Share",
            :d1 => "Last Trade Date",
            :d2 => "Trade Date",
            :e  => "Earnings/Share",
            :e1 => "Error Indication",
            :e7 => "EPS Estimate Current Year",
            :e8 => "EPS Estimate Next Year",
            :e9 => "EPS Estimate Next Quarter",
            :f6 => "Float Shares",
            :g  => "Day's Low",
            :h  => "Day's High",
            :j  => "Fifty two week Low",
            :k  => "Fifty two week High",
            :g1 => "Holdings Gain Percent",
            :g3 => "Annualized Gain",
            :g4 => "Holdings Gain",
            :g5 => "Holdings Gain Percent (Real-time)",
            :g6 => "Holdings Gain (Real-time)",
            :i  => "More Info",
            :i5 => "Order Book (Real-time)",
            :j1 => "Market Capitalization",
            :j3 => "Market Cap (Real-time)",
            :j4 => "EBITDA",
            :j5 => "Change From 52-week Low",
            :j6 => "Percent Change From 52-week Low",
            :k1 => "Last Trade (Real-time) With Time",
            :k2 => "Change Percent (Real-time)",
            :k3 => "Last Trade Size",
            :k4 => "Change From 52-week High",
            :k5 => "Percebt Change From 52-week High",
            :l  => "Last Trade (With Time)",
            :l1 => "Last Trade (Price Only)",
            :l2 => "High Limit",
            :l3 => "Low Limit",
            :m  => "Day's Range",
            :m2 => "Day's Range (Real-time)",
            :m3 => "Fifty day Moving Average",
            :m4 => "Two hundred day Moving Average",
            :m5 => "Change From 200-day Moving Average",
            :m6 => "Percent Change From 200-day Moving Average",
            :m7 => "Change From 50-day Moving Average",
            :m8 => "Percent Change From 50-day Moving Average",
            :n  => "Name",
            :n4 => "Notes",
            :o  => "Open",
            :p  => "Previous Close",
            :p1 => "Price Paid",
            :p2 => "Change in Percent",
            :p5 => "Price/Sales",
            :p6 => "Price/Book",
            :q  => "Ex-Dividend Date",
            :r  => "P/E Ratio",
            :r1 => "Dividend Pay Date",
            :r2 => "P/E Ratio (Real-time)",
            :r5 => "PEG Ratio",
            :r6 => "Price/EPS Estimate Current Year",
            :r7 => "Price/EPS Estimate Next Year",
            :s  => "Symbol",
            :s1 => "Shares Owned",
            :s7 => "Short Ratio",
            :t1 => "Last Trade Time",
            :t7 => "Ticker Trend",
            :t8 => "One yr Target Price",
            :v  => "Volume",
            :v1 => "Holdings Value",
            :v7 => "Holdings Value (Real-time)",
            :w  => "Fifty two week Range",
            :w1 => "Day's Value Change",
            :w4 => "Day's Value Change (Real-time)",
            :x  => "Stock Exchange",
            :y  => "Dividend Yield"
        }

        # tags and their associated method names
        @@tag_methods = {}

        @@tag_titles.each do |key, value|
            @@tag_methods[value.gsub(/[\s|-]+/, "_").gsub(/[^\w]/, "").downcase.to_sym] = key
        end

        attr_accessor :symbol, :values

        # takes a symbol, eg: GOOG and some options
        # valid options:
        # * :except - Array of tags to exclude
        # * :only - Array of tags to include
        def initialize symbol, options={}
            @symbol  = symbol
            @options = options
            @values  = {}
        end

        # request the data from the yahoo api, and populate
        # the current object with financial data
        def update
            CSV.parse(open(url).read) do |row|
                populate row
            end
        end

        # the tags to request from yahoo in compressed form
        def tags
            return @tags if @tags

            if @options.has_key? :only
                @tags = convert_methods(@options[:only])
            elsif @options.has_key? :except
                @tags = @@tag_titles.keys - convert_methods(@options[:except])
            else
                @tags = @@tag_titles.keys
            end

            @tags
        end

        # examples:
        # * quote.average_daily_volume
        # * quote.ask
        def method_missing sym, *args
            if @@tag_methods.has_key?(sym) or @values.has_key?(sym)
                value(sym)
            else
                super
            end
        end

        # print the list of tags along with the gathered values
        def print
            tags.each do |tag|
                puts "#{@@tag_titles[tag]} -> #{value(tag)}"
            end
        end

        protected

        def convert_methods syms
            syms.collect do |sym|
                @@tag_methods.has_key?(sym) ? @@tag_methods[sym] : sym
            end
        end

        # set the underlying tag values for the symbol
        def populate values
            @tags.each_with_index do |tag,idx|
                @values[tag] = parse_value(values[idx])
            end
        end

        # convert the value to a number if it needs it
        def parse_value value
            case value
            when /\d+/
                value.to_f
            else
                value
            end
        end

        # fetch a value from the underlying data hash
        def value sym
            @@tag_methods.has_key?(sym) ? value(@@tag_methods[sym]) : @values[sym]
        end

        # the yahoo api endpoint for stock data
        def url
            "http://quote.yahoo.com/d/quotes.csv?s=#{symbol}&f=#{tags.join("")}&e=.csv"
        end

    end

end