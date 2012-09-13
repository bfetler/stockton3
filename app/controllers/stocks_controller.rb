class StocksController < ApplicationController

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
# @stocks = Stock.where(companysymbol: params["symbols"])
    @bar = "baroo"
    @bar = StockService.foo
#   StockService.request_stocks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }
    end
  end

# how to run background job
# ruby cmd w/ rails env
# rails -r  # runner
# e.g. rails runner "StockService.fake_request"
# delayed_job, resque + reque scheduler
# use token, auth?  fastercsv, csv lib
# see httpparty, rest_client, typhus

  def sservice
# should only call StockService from background task
# should only receive notification after background task runs

#   res = StockService.request_stocks()
#   sash = StockService.parse_response(res)
    StockService.fake_request()

##   sash.each_value do |params|   # similar to update
##     stock = Stock.where("companysymbol = ?", params["companysymbol"]).first
##     if stock.update_attributes(params)
## puts "updated stock " + params.inspect
##     else
## puts "can't update stock " + params.inspect
##     end
##   end

# output is ignored, main purpose is to call StockService to update stocks
#   @stocks = Stock.first
    @stocks = "GOOG"

# Iain from carbon 5 says:
# rails shortcut to get just a few symbols w/o adding to db
# http://0.0.0.0:3000/stocks?symbols[]=GOOG&symbols[]=YHOO
# @stocks = Stock.where(companysymbol: params["symbols"])

# also how does rails know format json?
# see jQuery getJSON(), sets Request Headers: Accept
# see firebug GET headers, response

    puts "stocks to_json: " + @stocks.to_json

    respond_to do |format|
#     puts "getservice: format " + format.inspect
#     format.html { redirect_to :action => "index", notice: 'Stock service redirects to index.' }
      format.html { redirect_to :action => "index" }
# curl -s 'http://0.0.0.0:3000/getservice' > /dev/null 2>&1
# wget --header='Accept: application/json' 'http://0.0.0.0:3000/getservice'
# wget -q -O /dev/null --header='Accept: application/json' 'http://0.0.0.0:3000/getservice' > /dev/null 2>&1
# try setting headers to application/json instead of default html?
# next line for less output from cron cmd, not for real html
#     format.html { puts "getservice redirect_to index"; render json: @stocks }
#     format.json { render json: "index" }
# needs the following line for getJSON()
      format.json { puts "getservice json"; render json: @stocks }
    end
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
    @stock = Stock.new(params[:stock])

    respond_to do |format|
      if @stock.save
#       format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
      else
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
    @stock = Stock.find(params[:id])
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end
end
