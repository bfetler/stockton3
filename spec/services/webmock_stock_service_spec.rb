require 'spec_helper'
require 'webmock/rspec'  # needed for stub_request()
require 'net/http'

describe "webmock specs" do
# before(:each) do
#   WebMock.disable_net_connect!
# end
# after(:each) do
#   WebMock.allow_net_connect!
# end

  it "should print foo" do
    tmp = StockService.foo
    tmp.should eq("fooiee")
  end

  it "webmock should respond to request_stocks('GOOG')" do
    rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
#   stub_request(:get,
#     "http://finance.yahoo.com/d/quotes.csv?s=GOOG&f=snlc").
#     with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
#     to_return(:status => 200, :body => "", :headers => {})
    stub_request(:get,
      "http://finance.yahoo.com/d/quotes.csv?s=GOOG&f=snlc").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => rbody, :headers => {})
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
#   res.message.should eq("OK")
    res.class.name.should eq("Net::HTTPOK")
  end

  it "webmock should parse_response: request_stocks('GOOG')" do
    rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
    stub_request(:get,
      "http://finance.yahoo.com/d/quotes.csv?s=GOOG&f=snlc").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => rbody, :headers => {})
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    outp = StockService.parse_response(res)
    outp[0]["companysymbol"].should eq 'GOOG'
    outp[0]["value"].to_i.should be > 600
  end

end
