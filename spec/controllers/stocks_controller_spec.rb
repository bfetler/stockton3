require 'spec_helper'

describe StocksController do
  describe "GET index" do
    it "stubs all stocks to @stocks" do
      stock = stub_model(Stock)
      Stock.stub(:all) { [stock] }
      get :index
      assigns(:stocks).should eq([stock])
    end 
  end 
end
