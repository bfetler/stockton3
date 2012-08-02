require 'spec_helper'

describe StockService do
  it "should print foo" do
    tmp = StockService.foo
    tmp.should eq("fooiee")
  end
end
