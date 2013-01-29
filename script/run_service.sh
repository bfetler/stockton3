#!/bin/sh

tmpfile=/tmp/stockton.tmp

echo "START run_service" >> $tmpfile
date >> $tmpfile
which ruby >> $tmpfile
cd /media/BLinux/ub2/rex/eg323/stockton/

# to create stockton_rails wrapper:
#   rvm wrapper ruby-1.9.3-p125@gemsetaa stockton rails
#     => /home/ub2/.rvm/bin/stockton_rails   which is just a soft link
#        to /home/ub2/.rvm/wrappers/ruby-1.9.3-p125/rails

# echo "start rails runner" >> $tmpfile
# /home/ub2/.rvm/bin/stockton_rails runner -e development "StockService.fake_request" >> $tmpfile 2>&1
# /home/ub2/.rvm/bin/stockton_rails runner -e development "StockService.request" >> $tmpfile 2>&1

rake_cmd=/home/ub2/.rvm/gems/ruby-1.9.3-p125/bin/rake 
echo "$rake_cmd" >> $tmpfile
echo "start rake task" >> $tmpfile
$rake_cmd RAILS_ENV=development stocks:update >> $tmpfile 2>&1
# $rake_cmd RAILS_ENV=development stocks:random >> $tmpfile 2>&1

echo "DONE" >> $tmpfile
