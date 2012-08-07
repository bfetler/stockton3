require 'spec_helper'

describe StockService do
  it "should print foo" do
    tmp = StockService.foo
    tmp.should eq("fooiee")
  end

  it "should respond to request_stocks" do
    tmp = StockService.request_stocks
    tmp.code.should eq("200")
  end
end
