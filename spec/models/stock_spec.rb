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
    new_stock = Stock.create!(@attr)
    new_stock.should be_valid
  end

  it "should require a company name" do
    new_stock = Stock.new(@attr.merge(:companyname => ""))
    new_stock.should_not be_valid
  end

  it "should require a company symbol" do
    new_stock = Stock.new(@attr.merge(:companysymbol => ""))
    new_stock.should_not be_valid
  end

  it "should require a unique company symbol" do
    new_stock = Stock.create!(@attr)
    new_stock.should be_valid
    copy_stock = Stock.new(@attr.merge(:companyname => "Ogle"))
    copy_stock.should_not be_valid
  end

  it "company symbol should have no lowercase" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "Abc"))
    new_stock.should_not be_valid
  end

  it "company symbol should not have extraneous characters" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "_=7@"))
    new_stock.should_not be_valid
  end

  it "company symbol should have no more than 4 characters" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "Abcde"))
    new_stock.should_not be_valid
  end

  it "company symbol should have no more than 4 uppercase characters" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "ASDFG"))
    new_stock.should_not be_valid
  end

  it "company symbol should have no spaces" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "AB C"))
    new_stock.should_not be_valid
  end

  it "company symbol should have at least one uppercase character" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "A"))
    new_stock.should be_valid
  end

  it "company symbol may have two uppercase characters" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "CB"))
    new_stock.should be_valid
  end

  it "company symbol may have three uppercase characters" do
    new_stock = Stock.new(@attr.merge(:companysymbol => "VAR"))
    new_stock.should be_valid
  end

  it "company symbol valid_request should respond to http request" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "VAR"))
    new_stock.valid_request?.should be_true
    WebMock.disable_net_connect!
  end

  it "company symbol valid_request should reject invalid http request" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "ZYX"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end

  it "company symbol valid_request should reject lowercase" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "abc"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end

  it "company symbol valid_request should reject bad characters" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "_=7@"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end

  it "company symbol valid_request should reject more than 4 uppercase chars" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "ASDFG"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end

  it "company symbol valid_request should reject more than 4 chars" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "Abcde"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end

  it "company symbol valid_request should reject spaces" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "AB C"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end
  
# these are stupid tests, value is replaced by valid_request
  it "company symbol valid_request should reject non-number value" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "VAR", :value => "\n"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end
  
  it "company symbol valid_request should reject negative value" do
    WebMock.allow_net_connect!
    new_stock = Stock.new(@attr.merge(:companysymbol => "VAR", :value => "-4.4"))
    new_stock.valid_request?.should be_false
    WebMock.disable_net_connect!
  end

end
