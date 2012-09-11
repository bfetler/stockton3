class StockService

  require 'net/http'

# OUTFILE = "tmp/stock_file"

  def self.foo
    "fooiee"
  end

# wget -O outf 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'
# define output file
# define stock symbol list, keep in cache (local variable)
# keep in class variable in StockService, get with an action?
# hash of hashes, or hash of objects?

# apt-get install apache2-utils => get ab (ApacheBench http benchmarking tool)
# ab -c 5 -n 100 http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc
#  -c is number of simultaneous threads, -n is total number of requests

# http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22YHOO%22%2C%22AAPL%22%2C%22GOOG%22%2C%22MSFT%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=cbfunc

# see background_job, resque, delayed_job, whenever, simple_worker gem?

  def self.fake_request()
puts "fake_request"
    stocklist = Stock.all
    stocks = []
    stocklist.each { |s| stocks << s.companysymbol }
    stocklist.each do |stock|
#     puts "stock: " + stock.inspect
# calculate new random value
      oldval = stock["value"].to_f
      del = Random.new().rand(-5.0...5.0).round(2)
      if oldval+del < 0.0; del = -del; end
      newval = (oldval + del).round(2)  # add/sub not perfect, must round
      puts "  " + stock["companysymbol"] + " oldval:" + oldval.to_s + " del:" + del.to_s + " newval:" + newval.to_s
      sash = Hash.new
      sash["value"] = newval.to_s
      sash["delta"] = del.to_s
      if stock.update_attributes(sash)
puts "  updated stock " + sash.inspect
      else
puts "  can't update stock " + sash.inspect
      end
    end
  end

  def self.request_stocks(*stocks)

# do not try exec wget!  it kills rails server, hee hee
#   system "wget -O outf 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'"
#   system "wget -O " + OUTFILE + " 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'"

# just get list of all stocks for background process, don't use arg *stocks
    if stocks.empty?
      stocklist = Stock.all
      stocks = []
      stocklist.each { |s| stocks << s.companysymbol }
    end
#   stocklist = Stock.find(:all).collect(&:companysymbol)
#   puts "stocklist: " + stocklist.inspect

    puts "stocks is an Array? " + stocks.is_a?(Array).to_s
    sstr = stocks.join("+")
#   puts "stocks: " + sstr
    sstr = URI.escape(sstr)  # not needed if I check stock valid? beforehand
    puts "stocks escape uri: " + sstr
#   uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'
# need to parse stocks before adding raw text into uri? see uri::http?
    uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=' + sstr + '&f=snlc'
#   uri = URI(uri_str)
#   Net::HTTP.get(uri)
#   res = Net::HTTP.get_response(uri)
    res = self.fetch_uri(uri_str, 10)
#   puts res
    puts "res body:"
#   puts res.body if res.is_a?(Net::HTTPRedirection)
    puts res.body if res.is_a?(Net::HTTPSuccess)
#   puts "res body inspect:"
#   puts res.body.inspect if res.is_a?(Net::HTTPSuccess)
#   outa = res.body.split("\r\n")
#   puts outa.count
#   outa.each do |s|
#     puts "stock: " + s
#   end
    puts "res: "
    puts res.inspect
    res  # return response
  end

# output 3 string array: symbol, value, delta
# output array of 3 string arrays: symbol, value, delta
  def self.parse_response(res)
    puts res.body.inspect if res.is_a?(Net::HTTPSuccess)
    outa = res.body.split("\r\n")
    puts outa.count
#   outp = []
    outp = Hash.new
    outa.each_with_index do |s, index|
      puts "stock: " + s
#     outs = []
      sash = Hash.new
#     puts "  split: " + s.split(/\"/).inspect
#     puts "  split: " + s.split(/\W+/).inspect
#     puts "  2nd: " + s.split(/[<b>].[<\/b>]/).to_s
#     puts "  2nd: " + s[/[^<b>].[^<\/b>]/].to_s
#     puts "  2nd: " + s.split(/\"/)[5].inspect
#     puts "  2nd: " + s.split(/[<b>]/).to_s
#     puts "  split, : " + s.split(/,/).to_s
#     puts "  3rd: " + s.split(/,/)[3].to_s
#     puts "  3rd: " + s.split(/\"/)[7].split(/[" ]/)[0]
#     puts "  2nd: " + s.split(/,/)[2].split(/[^0-9+-\.]+/)[3].to_s

#     puts "  1st: " + s[/\w+/]
#     puts "  2nd: " + s.split(/[<b>]/)[3]
#     puts "  3rd: " + s.split(/,/)[3][/[0-9+-\.]+/]
#     outs << s[/\w+/].to_s
#     outs << s.split(/[<b>]/)[3]
#     outs << s.split(/,/)[3][/[0-9+-\.]+/]
      sash["companysymbol"] = s[/\w+/]
      sash["value"] = s.split(/[<b>]/)[3]
      sash["delta"] = s.split(/,/)[3][/[0-9+-\.]+/]

      stock = Stock.where("companysymbol = ?", sash["companysymbol"]).first
puts "stock db: " + stock.inspect
      if stock.nil?   # true if test env, or if not yet in db
        stock = Stock.new(sash)
      else
        if stock.update_attributes(sash)
puts "updated stock " + sash.inspect
        else
puts "can't update stock " + sash.inspect
        end
      end

#     outp << sash
      outp[index] = sash
#     outp[index.to_s] = sash
    end
# construct params hash?  
# should just update model here, send msg to ajax?
# what happens if there are many, many stocks?
    puts outp.inspect
    outp
# don't need to return all stocks hash, just true or false
  end

# Caleb suggests:
# background jobs in rails, resque?
# Net::HTTP in ruby, don't need to write to file
# backbone instead of ajax?

  def self.fetch_uri(uri_str, limit = 10)
  # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0

puts "fetch get_response uri: " + uri_str
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
