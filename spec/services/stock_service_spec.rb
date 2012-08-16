require 'spec_helper'

describe StockService do
  it "should print foo" do
    tmp = StockService.foo
    tmp.should eq("fooiee")
  end

  it "should stub http request_stocks" do
# well this is true by definition, not helpful
    StockService.stub(:request_stocks).and_return("200")
    StockService.request_stocks('GOOG').should eq("200")
  end

  it "request_stocks should receive 'GOOG'" do
# true by definition, not helpful
    StockService.should_receive(:request_stocks).with('GOOG')
    StockService.request_stocks('GOOG')
  end

  it "should stub parse_response" do
# well this is true by definition, not helpful
    rbody = "GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"
#   res.stub(:body).and_return(rbody)
#   StockService.stub(:fetch_uri).and_return(rbody)  # not quite right
    Net::HTTP.stub(:get_response).and_return(rbody)  # not quite right
#     should return res, res.body = rbody
#   StockService.stub(:parse_response).and_return(res)
#   StockService.parse_response(rbody).should eq(...)
  end

  it "should respond to one arg: request_stocks('GOOG')" do
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    res.message.should eq("OK")
    res.class.name.should eq("Net::HTTPOK")
  end

  it "should parse_response: request_stocks('GOOG')" do
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    outp = StockService.parse_response(res)
    outp[0]["companysymbol"].should eq 'GOOG'
    outp[0]["value"].to_i.should be > 600
  end

  it "should respond to two args: request_stocks('GOOG', 'AAPL')" do
    res = StockService.request_stocks('GOOG', 'AAPL')
    res.code.should eq("200")
    outp = StockService.parse_response(res)
    outp[0]["companysymbol"].should eq 'GOOG'
    outp[0]["value"].to_i.should be > 600
    outp[1]["companysymbol"].should eq 'AAPL'
    outp[1]["value"].to_i.should be > 600
  end
end
