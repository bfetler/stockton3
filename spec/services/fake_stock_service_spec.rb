require 'spec_helper'
# require 'webmock/rspec'
  require 'net/http'
# WebMock.allow_net_connect!  # enables http in other files

describe StockService do
  before(:all) do
    @stocka = FactoryGirl.create(:stock)
  end
  after(:all) do
    Stock.all.each { |s| s.destroy }
  end
# before(:each) do
#   WebMock.allow_net_connect!
# end
# after(:each) do
#   WebMock.disable_net_connect!
# end

# let(:stocka) { FactoryGirl.build(:stock) }
# let(:stocks) { 3.times.each.map { FactoryGirl.create(:stock) } }

  it "should create stocka" do
    @stocka.companyname.should eq("GooG A")
    @stocka.companysymbol.should eq("GGA")
    @stocka.value.should eq("100")
    @stocka.delta.should eq("10")
  end

  it "should randomize stocka" do
    StockService.fake_request()
    stock1 = Stock.first
    stock1.value.to_f.should be < 105.0
    stock1.value.to_f.should be >  95.0
    stock1.delta.to_f.should be <   5.0
    stock1.delta.to_f.should be >  -5.0
  end

  it "should add 3 stocks to db" do
    lambda do
      3.times.each.map { FactoryGirl.create(:stock) }
    end.should change(Stock, :count).by(3)
    3.times.each { Stock.last.destroy }
  end

  it "should create 3 more randomized stocks" do
    3.times.each.map { FactoryGirl.create(:stock) }
# factory values may be up to 'D' or 'G' depending on spec order
    Stock.all.each do |s|
      s.delta.to_f.should eq(10.0)
    end
    StockService.fake_request()
    Stock.all.each do |s|
      s.delta.to_f.should be <   5.0
      s.delta.to_f.should be >  -5.0
    end
    3.times.each { Stock.last.destroy }
  end

  it "setrandom request should call fake_request" do
    StockService.setrandom()  # don't need ()
    StockService.request()    # should call fake_request()
    stock1 = Stock.first
    stock1.value.to_f.should be < 105.0
    stock1.value.to_f.should be >  95.0
    stock1.delta.to_f.should be <   5.0
    stock1.delta.to_f.should be >  -5.0
#   StockService.unsetrandom()
  end

end
