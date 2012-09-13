class Stock < ActiveRecord::Base
  attr_accessible :companyname, :companysymbol, :delta, :value

# stock_regex = /\A[A-Z]{1,4}\Z/
  stock_regex = /^[A-Z]{1,4}$/

  validates :companyname,	:presence => true
  validates :companysymbol,	:presence => true,
  				:format => { :with => stock_regex },
 				:length => { :maximum => 4 }

# validate :is_a_stock

# StockService.request_stocks() response:
#   "GOOG","Google Inc.","Sep 12 - <b>690.88</b>","-1.31 - -0.19%"
#   "ZYX","ZYX","N/A - <b>0.00</b>","N/A - N/A"

# StockService.parse_response(res)
#   updated stock:
#   {"companysymbol"=>"GOOG", "value"=>"690.88", "delta"=>"-1.31"}
#   {"companysymbol"=>"ZYX", "value"=>"0.00", "delta"=>"-"}

  def is_a_stock
#   if # companysymbol.valid?
    if 0 > 1
#   if self.companysymbol.match(stock_regex)
#     only send http request if matches regex
      res = StockService.request_stocks(self.companysymbol)
#     sash = StockService.parse_response(res)
#     res.parse ...
    else
      errors.add("Invalid","stock symbol")
    end
  end
end
