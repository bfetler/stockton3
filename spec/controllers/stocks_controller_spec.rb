require 'spec_helper'
# require 'support/devise'  # same as spec_helper
# helper_method :current_user_or_guest
include Devise::TestHelpers
include ApplicationHelper
# I suppose I could stub current_user ... bleah

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

  describe "guest log" do
#   before(:each) do
#     @request.env["devise.mapping"] = Devise.mappings[:user]
#   end

    it "should get guestlog" do
      get 'guestlog'
      response.should be_success
    end

    it "should login guest" do
      get 'guestlog', :guest => "login"
      session[:guest_login].should be_true
    end

    it "should logout guest" do
      get 'guestlog', :guest => "logout"
      session[:guest_login].should_not be_true
    end

    it "should logout guest w/ empty string" do
      get 'guestlog', :guest => ""
      session[:guest_login].should_not be_true
    end

    it "current_user_or_guest method should exist" do
      current_user_or_guest.should_not be_nil
    end
  end

end
