require 'spec_helper'

describe StocksController do
# views must exist, but can be empty files (unless render_views)

  describe "GET index" do
    it "stub all stocks to @stocks" do
      stock = stub_model(Stock)
      Stock.stub(:all) { [stock] }
      get :index
      assigns(:stocks).should eq([stock])
    end 
  end 
end
