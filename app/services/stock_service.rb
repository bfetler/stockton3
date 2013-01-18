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
    StockService.parse_response(res)
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
  
  def self.parse_csv(s)
    sash = Hash.new
    sash["companysymbol"] = s[/\w+/]
    sash["value"] = s.split(/[<>]/)[2]
    sash["delta"] = s.split(/,/)[3][/[0-9+-\.]+/]
    sash
  end
  
  # parse response body, output stocks hash
  def self.parse_body(res)  # rename to self.parse_response(res)
    puts "** parse_body"
    puts "res body: " + res.body.inspect if res.is_a?(Net::HTTPSuccess)
    outa = res.body.split("\r\n")
    outp = Hash.new
    outa.each_with_index do |s, index|
      sash = self.parse_csv(s)
      outp[index] = sash
    end
# what happens if there are many, many stocks?
    puts "outp: " + outp.inspect
    outp
  end

  def self.parse_response(res)
    outp = StockService.parse_body(res)
    
    puts "** parse_response"
    puts "  outp class: " + outp.class.to_s + " : " + outp.inspect
    outp.each do |index, s|
      puts "stock: " + s.to_s
      sash = s

      stock = Stock.where("companysymbol = ?", sash["companysymbol"]).first
puts "stock db: " + stock.inspect
      if stock.nil?   # true if test env, or if not yet in db
        # stock = Stock.new(sash)
        # stock.save  # if not already in db, how was it created?
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
    outp  # only used in specs
# don't need to return all stocks hash, just true or false
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
