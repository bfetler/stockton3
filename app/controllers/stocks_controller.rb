class StocksController < ApplicationController

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
# @stocks = Stock.where(companysymbol: params["symbols"])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }
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
# next two lines useful for random test, not for real stock request
    params[:stock][:value] = 0.0 if params[:stock][:value].nil?
    params[:stock][:delta] = 0.0 if params[:stock][:delta].nil?
    @stock = Stock.new(params[:stock])
#   pp = @stock.valid_request?
#   if Stock.find(params[:stock]).any?
#     add to User's stock list, else try to save ...

    respond_to do |format|
      if @stock.valid_request? and @stock.save
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
