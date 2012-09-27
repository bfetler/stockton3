class Stock < ActiveRecord::Base
  attr_accessible :companyname, :companysymbol, :delta, :value

# stock_regex = /\A[A-Z]{1,4}\Z/
  SREGEX = /^[A-Z]{1,4}$/

  validates :companyname,	:presence => true
  validates :companysymbol,	:presence => true,
				:uniqueness => true,
  				:format => { :with => SREGEX },
 				:length => { :maximum => 4 }

# validate :valid_request?

# StockService.request_stocks() response:
#   "GOOG","Google Inc.","Sep 12 - <b>690.88</b>","-1.31 - -0.19%"
#   "ZYX","ZYX","N/A - <b>0.00</b>","N/A - N/A"
#   "CB","Chubb Corporation","Sep 12 - <b>75.80</b>","+0.58 - +0.77%"
#   "TSLA","Tesla Motors, Inc","Sep 12 - <b>28.28</b>","+0.48 - +1.73%"

# StockService.parse_response(res)
#   updated stock:
#   {"companysymbol"=>"GOOG", "value"=>"690.88", "delta"=>"-1.31"}
#   {"companysymbol"=>"ZYX", "value"=>"0.00", "delta"=>"-"}

  def valid_request?
# only want to run this on create(), not update()
# validations run on both, use separate call
#   if # companysymbol.valid?
    if self.companysymbol.match(SREGEX)
puts "company symbol passes regex"
#     only send http request if matches regex
      res = StockService.request_stocks(self.companysymbol)
#     sash = StockService.parse_response(res)
#     res.parse ...
      if res.is_a?(Net::HTTPSuccess)
        value = "0.00"
        delta = "-"
        outa = res.body.split("\r\n")
# puts "outa count " + outa.count.to_s
        outa.each_with_index do |s, index|
  puts "s= " + s
          value = s.split(/[<>]/)[2]
          delta = s.split(/,/)[3][/[0-9+-\.]+/]
  puts "value=" + value + " delta=" + delta
        end
        if value == "0.00" && delta == "-"
# don't need both conditions to fail?
          errors.add("Invalid","stock symbol 3")
          return false
        end
      else
        errors.add("Invalid","stock symbol 2")
        return false
      end
    else
      errors.add("Invalid","stock symbol")
      return false
    end
    true
  end
end
