require 'spec_helper'

describe Stock do
# need stock.rb model w/ validations, migration, rake db:test:prepare to pass

  before(:each) do
    @attr = { :companyname 	=> "Google",
              :companysymbol 	=> "GOOG",
              :value  	 	=> "567.8",
              :delta  	 	=> "12.3"
            }
  end

  it "should create stock" do
    Stock.create!(@attr)
  end

  it "should require a company name" do
    new_stock = Stock.new(@attr.merge(:companyname => ""))
    new_stock.should_not be_valid
  end

  it "should require a company symbol" do
    new_stock = Stock.new(@attr.merge(:companysymbol => ""))
    new_stock.should_not be_valid
  end

end
