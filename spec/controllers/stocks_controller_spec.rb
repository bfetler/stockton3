require 'spec_helper'

describe StocksController do
# views must exist, but can be empty files (unless render_views)

# before(:each) do
#   @attr = { :companyname      => "Google",
#             :companysymbol    => "GOOG",
#             :value            => "567.8",
#             :delta            => "12.3"
#           }
#   Stock.create!(@attr)
# end

  describe "GET index" do
    before(:each) do
      @attr = { :companyname      => "Google",
                :companysymbol    => "GOOG",
                :value            => "567.8",
                :delta            => "12.3"
              }
      @user = { :email => "fred@flintstone.com",
                :password => "abc123"
              }
      Stock.create!(@attr)
      User.create!(@user)
#     let (:user) { User.create!(@user) }
#     sign_in user
    end

    it "stub all stocks to @stocks" do
      stock = stub_model(Stock)
      Stock.stub(:all) { [stock] }
puts "[stock] = " + [stock].inspect
      get :index
      assigns(:stocks).should eq([stock])
    end 
  end 
end
