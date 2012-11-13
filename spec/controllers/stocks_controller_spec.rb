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
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @attr = { :companyname      => "Google",
                :companysymbol    => "GOOG",
                :value            => "567.8",
                :delta            => "12.3"
              }
#     @user = { :email => "fred@flintstone.com",
#               :password => "abc123"
#             }
#     user = User.create!(@user)  # works

#     let (:user) { User.create!(@user) }
#     @user.confirm!
#     sign_in @user

      user = FactoryGirl.create(:user)
      sign_in user

      Stock.create!(@attr)
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
