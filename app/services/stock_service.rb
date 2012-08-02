class StockService

  OUTFILE = "tmp/stock_file"

  def self.foo
    "fooiee"
  end

# wget -O outf 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'
# define output file
# define stock symbol list

  def self.request_stocks
# do not try exec wget!  it kills rails server, hee hee
#   system "wget -O outf 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'"
    system "wget -O " + OUTFILE + " 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'"
  end

# Caleb suggests:
# background jobs in rails, resque?
# Net::HTTP in ruby, don't need to write to file
# backbone instead of ajax?

  def self.read_stocks
# read and parse outf, return values
  end
end
