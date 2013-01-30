class StocksController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :guestlog]
  before_filter :is_admin?, :only => [:sservice]  # get rid of?
# include ApplicationHelper

  # GET /stocks
  # GET /stocks.json
  def index
    puts "current_user: " + current_user.email
    puts "params: " + params.to_s
#   puts current_user.methods.sort.join(", ")

#   @stocks = Stock.all
# @stocks = Stock.where(companysymbol: params["symbols"])
    if current_user.admin?
      @stocks = Stock.all
    else
      @stocks = current_user.stocks
    end
# check_random_flag()
    if params[:random] == "true"  # gets appended to URL, not optimal
      puts "stocks class: " + @stocks.class.to_s + " " + @stocks.count.to_s
      @stocks = Stock.randomize(@stocks)
    end
    puts "session: " + session.to_s

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }  # needed for getJSON
    end
  end


# should only call StockService from background task
  def sservice

    puts "sservice params: " + params.inspect
    if current_user.admin?
      StockService.request
    end
    @stocks = "GOOG"
    
    # output is ignored, main purpose is to call StockService to update stocks
    #   puts "stocks to_json: " + @stocks.to_json
    
    redirect_to stocks_path

    #respond_to do |format|
    #  format.html { redirect_to :action => "index" }
    #  format.json { puts "sservice json"; render json: @stocks }
    #end
  end

  def home
    if user_signed_in?
      redirect_to stocks_path
    else
      redirect_to new_user_session_path
    end
  end

  def guestlog
#   session[:guest_login] = nil
puts "guestlog params: " + params.to_s  
# {"controller"=>"stocks", "action"=>"guestlog"}
    if params[:guest] == "login"
#     session[:guest_login] = true
#     sign_in guest_user
      g = guest_user
      puts "guestlog user: " + g.inspect
      sign_in g
    end
    redirect_to stocks_path
  end

  # GET /stocks/new
  # GET /stocks/new.json
  def new
    @stock = Stock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stock }
    end
  end

  # POST /stocks
  # POST /stocks.json
  def create
    # initialize value, delta if not defined
    params[:stock][:value] ||= 0.0
    params[:stock][:delta] ||= 0.0

    @stock = Stock.new(params[:stock])

#   Stock in current_user.stocks ?
#   Stock.where(stocksymbol = ?)

# if Stock.new fails, these will both be empty, which is fine
    #in_stocklist = current_user.stocks.select do |s|
    #  s.companysymbol == @stock.companysymbol
    #end
#    in_stocklist = @stock.is_in_stocklist(current_user)
    is_in_user_stocklist = is_in_user_stocklist?(@stock)
#   could use current_user.stocks.where(companysymbol ...)
#   in_db = Stock.where("companysymbol = ?", @stock.companysymbol)
    stock_from_db = @stock.find_in_db
    puts "in_stocklist: " + is_in_user_stocklist.inspect + "; from_db: " + stock_from_db.inspect
    
#    puts "already in stocklist? " + in_stocklist.any?.to_s
#    puts "already in db? " + in_db.any?.to_s

    respond_to do |format|
      if is_in_user_stocklist
  puts "stock already in current user list: " + @stock.companysymbol
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
#     elsif (in_db.any?) || (@stock.valid_request? and @stock.save)
      elsif stock_from_db.any?
puts "adding stock in db to current user list: " + @stock.companysymbol
puts "stock in db: " + stock_from_db.to_s
        current_user.stocks << stock_from_db
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
      elsif @stock.valid_request? and @stock.save
#     if @stock.valid_request? and @stock.save
puts "save stock, add to current user list: " + @stock.companysymbol
        current_user.stocks << @stock  # turn this line into a method?
#       format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
      else
puts "cannot add stock: " + @stock.companysymbol
        format.html { render action: "new" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
# should only destroy if admin; else just remove from current_user.stocks
    if current_user.admin?
      @stock = Stock.find(params[:id])
      @stock.users.clear
      @stock.destroy
    else
      current_user.stocks.clear
    end

    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end
end
