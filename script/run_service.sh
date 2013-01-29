#!/bin/sh

echo "start run_service" >> /tmp/stockton.tmp
date >> /tmp/stockton.tmp
which ruby >> /tmp/stockton.tmp
cd /media/BLinux/ub2/rex/eg323/stockton/
date >> /tmp/stockton.tmp
echo "PATH: " $PATH >> /tmp/stockton.tmp

# to create stockton_rails:
#   rvm wrapper ruby-1.9.3-p125@gemsetaa stockton rails
#     => /home/ub2/.rvm/bin/stockton_rails   which is just a soft link
#        to /home/ub2/.rvm/wrappers/ruby-1.9.3-p125/rails

# echo "start rails runner" >> /tmp/stockton.tmp
# /home/ub2/.rvm/bin/stockton_rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1
# /home/ub2/.rvm/bin/stockton_rails runner -e development "StockService.request" >> /tmp/stockton.tmp 2>&1

echo "start rake task" >> /tmp/stockton.tmp
# rake stocks:random >> /tmp/stockton.tmp
cd /media/BLinux/ub2/rex/eg323/stockton && /home/ub2/.rvm/gems/ruby-1.9.3-p125/bin/rake RAILS_ENV=development stocks:random >> /tmp/stockton.tmp

