namespace :stocks do
  
  desc "update stocks"
  task :update => [:environment] do |t, args|
    puts "Stock count: #{Stock.count}"
    StockService.request
  end
  
  desc "randomize stocks"
  task :random => [:environment] do |t, args|
    puts "Stock count: #{Stock.count}"
    StockService.fake_request
  end

end
