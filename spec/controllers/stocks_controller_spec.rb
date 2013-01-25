require 'spec_helper'
# require 'support/devise'  # same as spec_helper
# helper_method :current_user_or_guest
include Devise::TestHelpers
include ApplicationHelper
# I suppose I could stub current_user ... bleah

describe StocksController do
# views must exist, but can be empty files (unless render_views)

# render_views

# before(:each) do
#   @attr = { :companyname      => "Google",
#             :companysymbol    => "GOOG",
#             :value            => "567.8",
#             :delta            => "12.3"
#           }
#   Stock.create!(@attr)
# end

  before(:each) do
    WebMock.allow_net_connect!
  end
  
  after(:each) do
    WebMock.disable_net_connect!
  end

  describe "factory user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @attr = { :companyname      => "Google",
                :companysymbol    => "GOOG",
                :value            => "567.8",
                :delta            => "12.3"
              }
      
      @yahoo_attr = { :companyname   => "Yahoo",
                      :companysymbol => "YHOO"        
      }
      
#     @user = { :email => "fred@flintstone.com",
#               :password => "abc123"
#             }
#     user = User.create!(@user)  # works

#     let (:user) { User.create!(@user) }
#     @user.confirm!
#     sign_in @user

      @user = FactoryGirl.create(:user)
      sign_in @user

      @stock = Stock.create!(@attr)
    end
    
    describe "user sign in" do
      it "should have a current_user" do
        subject.current_user.should_not be_nil
      end
    end
    
    describe "GET index" do
      before(:each) do
#        @user.stocks << @stock
        subject.current_user.stocks << @stock
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should render index view" do
        get :index
        response.should render_template('index')
      end
    end
    
    describe "GET new" do
      it "should render new view" do
        get :new
        response.should render_template('new')
      end
    end

    describe "POST create" do
      describe "Google in user stocks:" do
        before(:each) do
          subject.current_user.stocks << @stock
        end
        
        it "should not create already existing stock" do
          lambda do
            post :create, :stock => @attr
          end.should_not change(Stock, :count)
        end
        
        it "should redirect already existing stock to index view" do
          post :create, :stock => @attr
#         expect(response).to redirect_to(stocks_path)
          response.should redirect_to(stocks_path)
        end
        
        it "should not add already existing stock to user stocks" do
          post :create, :stock => @attr
          subject.current_user.stocks.count.should be(1)
        end
        
        it "should create new stock" do
          lambda do
            post :create, :stock => @yahoo_attr
          end.should change(Stock, :count).by(1)
        end
        
        it "should redirect new stock to index view" do
          post :create, :stock => @yahoo_attr
          response.should redirect_to(stocks_path)
        end
        
        it "should add new stock to user stocks" do
          post :create, :stock => @yahoo_attr
          subject.current_user.stocks.count.should be(2)
        end
        
        it "should render new template for invalid stock" do
          post :create, :stock => @attr.merge( :companysymbol => "ZYX" )
          response.should render_template('new')
        end
        
        it "should not add invalid stock to database" do
          lambda do
            post :create, :stock => @attr.merge( :companysymbol => "ZYX" )
          end.should_not change(Stock, :count)
        end
      end
      
      describe "Google not in user stocks:" do
        it "should not create already existing stock" do
          lambda do
            post :create, :stock => @attr
          end.should_not change(Stock, :count)
        end
        
        it "should redirect already existing stock to index view" do
          post :create, :stock => @attr
          response.should redirect_to(stocks_path)
        end
        
        it "should create new stock" do
          lambda do
            post :create, :stock => @yahoo_attr
          end.should change(Stock, :count).by(1)
        end
        
        it "should redirect new stock to index view" do
          post :create, :stock => @yahoo_attr
          response.should redirect_to(stocks_path)
        end
      end
    end
    
    describe "DELETE stocks" do
      before(:each) do
        subject.current_user.stocks << @stock
      end
      
      it "should remove stocks from user" do
        delete 'destroy', :id => @stock
        subject.current_user.stocks.should be_empty
      end
      
      it "should not change Stocks in database" do
        lambda do
          delete 'destroy', :id => @stock
        end.should_not change(Stock, :count)
      end
    end
    
  end
  
  describe "stub stocks" do

    it "stub all stocks to @stocks" do
      stock = stub_model(Stock)
      Stock.stub(:all) { [stock] }
puts "[stock] = " + [stock].inspect
      get :index
      assigns(:stocks).should eq([stock])
    end
    
  end 

  describe "guest log" do
    before(:each) do
#      @request.env["devise.mapping"] = Devise.mappings[:user]
#      factory_guest = FactoryGirl.create(:user)
#      factory_guest.role = "guest"
#puts "saving factory_guest"
#      factory_guest.save
#puts "saved factory_guest"
      @guest = create_guest_user
    end

    it "should get guestlog" do
      get 'guestlog'
#     response.should be_success  # not! it redirects
      expect(response).to redirect_to(stocks_path)
    end

    it "should login guest" do
      get 'guestlog', :guest => "login"
#     need to create guest_user
#     session[:guest_login].should be_true
#     current_user.should be(factory_guest)
      expect(response).to redirect_to(stocks_path)
#     u = User.where("role = ?", "guest").first
#     u.should_not be_nil
    end
    
    #it "should set current_user to guest" do
    #  get 'guestlog', :guest => "login"
    #  current_user.should_not be_nil
    #end
    
  end

end
