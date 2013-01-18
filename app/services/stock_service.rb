class StockService

  require 'net/http'

# define stock symbol list, keep in cache (local variable) or db?
# keep in class variable in StockService, get with an action?

# remove this method  1/15/13
  def self.fake_request_old()   # should handle (*stocks)?
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
  
# public
# def self.request_values()
  def self.request(*stocks)
    res = StockService.request_stocks(*stocks)
    stocks_hash = StockService.parse_response(res)
    StockService.update_db(stocks_hash)
  end

  def self.request_stocks(*stocks)

# for background process, just get list of all stocks
# use arg *stocks to test if a stock is valid?
    if stocks.empty?
      stocks = []
      Stock.all.each { |s| stocks << s.companysymbol }
    end
#   stocklist = Stock.find(:all).collect(&:companysymbol)
#   puts "stocklist: " + stocklist.inspect

    puts "stocks is an Array? " + stocks.is_a?(Array).to_s
    sstr = stocks.join("+")
    puts "stocks: " + sstr
# need to parse stocks before adding raw text into uri? see uri::http?
    sstr = URI.escape(sstr)  # not needed if I check stock valid? beforehand
    puts "stocks escape uri: " + sstr
#   uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'
    uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=' + sstr + '&f=snlc'
# max length of uri?  2048 in IE, longer in others.  use POST not GET?
#   47 chars + 5 * stocks (5 = 4 char + "+"); (2047-47)/5 = 400 stocks max
# if doing in a loop, could start a thread for each rather than
#   wait for response --jonah c5

    res = self.fetch_uri(uri_str, 10)
    puts "res: "
    puts res.inspect
    puts "res body:"
    puts res.body if res.is_a?(Net::HTTPSuccess)
#   puts res.body.inspect if res.is_a?(Net::HTTPSuccess)
    res  # return response
  end
  
  # stock hash from comma-separated-value string
  def self.parse_csv(str)
#   e.g. s = '"GOOG","Google Inc.","Sep 12 - <b>690.88</b>","-1.31 - -0.19%"'
    sash = Hash.new
#   sash["value"] = "0.00"
#   sash["delta"] = "-"
    sash["companysymbol"] = str[/\w+/]
    sash["value"] = str.split(/[<>]/)[2]
    sash["delta"] = str.split(/,/)[3][/[0-9+-\.]+/]
    sash
  end
  
  # parse response body, output stocks hash
  def self.parse_response(res)  # rename to self.parse_response(res)
    puts "** parse_response"
    puts "res body: " + res.body.inspect if res.is_a?(Net::HTTPSuccess)
    stocks_array = res.body.split("\r\n")
    stocks_hash = Hash.new
    stocks_array.each_with_index do |s, index|
      sash = self.parse_csv(s)
      stocks_hash[index] = sash
    end
# what happens if there are many, many stocks?
    puts "stocks_hash: " + stocks_hash.inspect
    stocks_hash
  end

  def self.update_db(stocks_hash)
#    stocks_hash = StockService.parse_response(res)
    
    puts "** update_db"
    puts "  stocks_hash class: " + stocks_hash.class.to_s + " : " + stocks_hash.inspect
    stocks_hash.each do |index, sash|
      puts "stock: " + sash.to_s

      stock = Stock.where("companysymbol = ?", sash["companysymbol"]).first
puts "stock db: " + stock.inspect
      if stock.nil?   # true if test env, or if not yet in db
        # stock = Stock.new(sash)
        # stock.save  # if not already in db, how was it created? do not want to save
      else
        if stock.update_attributes(sash)
puts "updated stock " + sash.inspect
        else
puts "can't update stock " + sash.inspect
        end
      end

    end
# just update model here, could send msg to redisplay view?
#     websockets?  ajax?  backbone?
# what happens if there are many, many stocks?
# don't need to return all stocks hash
  end

private
# copied from a web site somewhere (rubydoc http)
# replace with httpparty, rest_client gem?
  def self.fetch_uri(uri_str, limit = 10)
  # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0

# puts "fetch get_response uri: " + uri_str
    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then  # 200, 2xx
      response
    when Net::HTTPRedirection then  # 301, 3xx
      location = response['location']
      warn "redirected to #{location}"
      self.fetch_uri(location, limit - 1)
# 400 my request error
# 500 their request error
    else
      response.value
    end
  end

end
