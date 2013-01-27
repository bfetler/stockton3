desc "run stock service"

# task :default => [:execrun]

task :sservice => [:environment] do |t, args|
  puts "Stock count: #{Stock.count}"
# StockService.fake_request
  StockService.request
end

task :yayy do
# ruby "StockService.fake_request"
  puts "yayy!!"
end

file "execrun" do
  sh "../../script/run_service.sh"
end
