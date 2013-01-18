require 'spec_helper'
require 'net/http'

describe StockService do
  
  before(:each) do
    WebMock.allow_net_connect!
  end
  
  after(:each) do
    WebMock.disable_net_connect!
  end

  it "should stub request_stocks" do
    StockService.stub(:request_stocks).and_return("200")
    StockService.request_stocks('GOOG').should eq("200")
  end

  it "request_stocks should receive 'GOOG'" do
    StockService.should_receive(:request_stocks).with('GOOG')
    StockService.request_stocks('GOOG')
  end

  it "request_stocks should respond to fetch_uri stub" do
    rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
    http_mock = double('Net::HTTPResponse')
    http_mock.stub(:code => '200', :message => "OK",
      :content_type => "text/html",
      :body => rbody)
    StockService.stub(:fetch_uri).and_return(http_mock)  # okay!
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    res.message.should eq("OK")
    res.body.should eq(rbody)
  end

  it "parse_response should respond to fetch_uri stub" do
    rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
    http_mock = double('Net::HTTPResponse')
    http_mock.stub(:code => '200', :message => "OK",
      :content_type => "text/html",
      :body => rbody)
    StockService.stub(:fetch_uri).and_return(http_mock)  # okay!
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    res.body.should eq(rbody)
    outp = StockService.parse_response(res)
    outp[0]["companysymbol"].should eq 'GOOG'
    outp[0]["value"].to_i.should be > 600
  end

  it "should respond to one arg: request_stocks('GOOG')" do
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    res.message.should eq("OK")
    res.class.name.should eq("Net::HTTPOK")
  end
  
  it "should parse_csv correctly" do
    body_line = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
    sash = StockService.parse_csv(body_line)
    sash["companysymbol"].should eq("GOOG")
#   sash["companyname"].should eq("Google Inc.")  # should ignore it
    sash["companyname"].should be_nil
    sash["value"].should eq("667.54")
    sash["delta"].should eq("-1.12")
  end

  it "should parse_response body: request_stocks('GOOG')" do
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    outp = StockService.parse_response(res)
    outp[0]["companysymbol"].should eq 'GOOG'
    outp[0]["value"].to_i.should be > 600
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
    outp[1]["value"].to_i.should be > 400
  end

end
