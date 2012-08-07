class StockService

  require 'net/http'

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
#   system "wget -O " + OUTFILE + " 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'"
    uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'
#   uri = URI(uri_str)
#   Net::HTTP.get(uri)
#   res = Net::HTTP.get_response(uri)
    res = self.fetch_uri(uri_str, 10)
#   puts res
    puts "res info (header?)"
    puts "  code: " + res.code
    puts "  message: " + res.message
    puts "  class name: " + res.class.name
    puts "res body:"
#   puts res.body if res.is_a?(Net::HTTPRedirection)
    puts res.body if res.is_a?(Net::HTTPSuccess)
    puts "res body inspect:"
    puts res.body.inspect if res.is_a?(Net::HTTPSuccess)
    outa = res.body.split("\r\n")
    puts outa.count
    outa.each do |s|
      puts "stock: " + s
    end
    res  # return response
  end

# Caleb suggests:
# background jobs in rails, resque?
# Net::HTTP in ruby, don't need to write to file
# backbone instead of ajax?

  def self.fetch_uri(uri_str, limit = 10)
  # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0

    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then  # 200, 2xx
      response
    when Net::HTTPRedirection then  # 301, 3xx
      location = response['location']
      warn "redirected to #{location}"
      self.fetch_uri(location, limit - 1)
    else
      response.value
    end
  end

  def self.read_stocks
# read and parse outf, return values
  end
end
