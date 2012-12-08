class StocksController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :guestlog]
  before_filter :isadmin?, :only => [:sservice]

  # GET /stocks
  # GET /stocks.json
  def index
#   @stocks = Stock.all
# @stocks = Stock.where(companysymbol: params["symbols"])
    @stocks = current_user.stocks
# check_random_flag()
    puts "session: " + session.to_s

    respond_to do |format|
      format.html # index.html.erb
#     format.json { render json: @stocks }  # needed for getJSON
    end
  end


  def sservice
# should only call StockService from background task
# should only allow if is_admin?
# user should receive notification after background task runs

puts "sservice params: " + params.inspect

    if params[:update] == "random"
      StockService.setrandom
    elsif params[:update]
      StockService.unsetrandom
    end

    StockService.request

    @stocks = "GOOG"
# output is ignored, main purpose is to call StockService to update stocks
#   puts "stocks to_json: " + @stocks.to_json

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.json { puts "sservice json"; render json: @stocks }
    end
  end

  def home
    c = current_user_or_guest
    puts "home current_user_or_guest: " + c.to_s + " ; class " + c.class.to_s
#   puts "home current_user_or_guest methods: " + c.methods.to_s
    if user_signed_in?
      redirect_to stocks_path
    else
#     render :layout => false
#     render 'users/sign_in'
#     render 'devise/sessions/new'
#     redirect_to :controller => "devise/sessions", :action => "new"
      redirect_to new_user_session_path
    end
  end

  def guestlog
    if params[:guest] == "login"
      session[:guest_login] = true
    elsif params[:guest]
      session[:guest_login] = nil
    end
#   redirect_to home_path
    redirect_to stocks_path
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
    @stock = Stock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stock }
    end
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

  # GET /stocks/1/edit
  def edit
    @stock = Stock.find(params[:id])
  end

  # POST /stocks
  # POST /stocks.json
  def create
# next two lines useful for both random test and real stock request
    params[:stock][:value] = 0.0 if params[:stock][:value].nil?
    params[:stock][:delta] = 0.0 if params[:stock][:delta].nil?
    @stock = Stock.new(params[:stock])
#   pp = @stock.valid_request?
#   if Stock.find(params[:stock]).any?
#     add to User's stock list, else try to save ...

#   Stock in current_user.stocks ?
#   Stock.where(stocksymbol = ?)

# if Stock.new fails, these will both be empty, which is fine
    in_stocklist = current_user.stocks.select do |s|
      s.companysymbol == @stock.companysymbol
    end
#   could use current_user.stocks.where(companysymbol ...)
    in_db = Stock.where("companysymbol = ?", @stock.companysymbol)
    puts "already in stocklist? " + in_stocklist.any?.to_s
    puts "already in db? " + in_db.any?.to_s

    respond_to do |format|
      if in_stocklist.any?
  puts "stock already in current user list: " + @stock.companysymbol
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
#     elsif (in_db.any?) || (@stock.valid_request? and @stock.save)
      elsif in_db.any?
puts "adding stock in db to current user list: " + @stock.companysymbol
puts "stock in db: " + in_db.to_s
        current_user.stocks << in_db  # turn this line into a method?
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

  # PUT /stocks/1
  # PUT /stocks/1.json
  def update
    @stock = Stock.find(params[:id])

    respond_to do |format|
      if @stock.update_attributes(params[:stock])
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
# should only destroy if admin; else just remove from current_user.stocks
    @stock = Stock.find(params[:id])
    @stock.users.clear
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end
end
