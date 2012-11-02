require 'spec_helper'
# require 'webmock/rspec'
  require 'net/http'
# WebMock.allow_net_connect!  # enables http in other files

describe StockService do
  before(:each) do
    WebMock.allow_net_connect!
  end
  after(:each) do
    WebMock.disable_net_connect!
  end

  it "should stub request_stocks" do
# well this is true by definition, not helpful
    StockService.stub(:request_stocks).and_return("200")
    StockService.request_stocks('GOOG').should eq("200")
  end

  it "request_stocks should receive 'GOOG'" do
# true by definition, not helpful
    StockService.should_receive(:request_stocks).with('GOOG')
    StockService.request_stocks('GOOG')
  end

  it "request_stocks should respond to fetch_uri stub" do
# true by definition, not helpful
#   res = Net::HTTPResponse.new()  # new(path, initheader=nil)
#   rbody = "GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"
    rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
#   http_mock = mock('Net::HTTPResponse')
    http_mock = double('Net::HTTPResponse')
    http_mock.stub(:code => '200', :message => "OK",
      :content_type => "text/html",
      :body => rbody)
#   res.stub(:body).and_return(rbody)
    StockService.stub(:fetch_uri).and_return(http_mock)  # okay!
#   Net::HTTP.stub(:get_response).and_return(http_mock)  # not quite right
#     should return res, res.body = rbody
#   stub_request(:get, ).with
#   StockService.stub(:parse_response).and_return(res)
#   StockService.parse_response(rbody).should eq(...)
    res = StockService.request_stocks('GOOG')
    res.code.should eq("200")
    res.message.should eq("OK")
    res.body.should eq(rbody)
  end

  it "parse_response should respond to fetch_uri stub" do
# true by definition, not helpful
#   rbody = "GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"
    rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
#   http_mock = mock('Net::HTTPResponse')
    http_mock = double('Net::HTTPResponse')
    http_mock.stub(:code => '200', :message => "OK",
      :content_type => "text/html",
      :body => rbody)
    StockService.stub(:fetch_uri).and_return(http_mock)  # okay!
#   Net::HTTP.stub(:get_response).and_return(http_mock)  # not quite right
#   StockService.parse_response(rbody).should eq(...)
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
    outp[1]["value"].to_i.should be > 550
  end

  describe "test random variable:" do
    it "initial random value should be false" do  # no guarantee of order
      StockService.getrandom().should be false
    end

    it "setrandom should set true" do
      StockService.setrandom
      StockService.getrandom().should be true
      StockService.unsetrandom  # needed if init random value called after
    end

    it "unsetrandom should set false" do
      StockService.unsetrandom
      StockService.getrandom().should be false
    end

    it "should parse_response: request('GOOG')" do
      StockService.unsetrandom
      outp = StockService.request('GOOG')
      outp[0]["companysymbol"].should eq 'GOOG'
      outp[0]["value"].to_i.should be > 600
    end
  end

end
