#!/bin/sh
# cd /media/BLinux/ub2/rex/eg323/stockton/
# rails runner --environment=development "StockService.fake_request"
# rails runner -e development "StockService.fake_request"

# GEM_HOME=/home/ub2/.rvm/gems/ruby-1.9.3-p125
# GEM_PATH=/home/ub2/.rvm/gems/ruby-1.9.3-p125:/home/ub2/.rvm/gems/ruby-1.9.3-p125@global
# MY_RUBY_HOME=/home/ub2/.rvm/rubies/ruby-1.9.3-p125
# export GEM_HOME GEM_PATH MY_RUBY_HOME

# source $HOME/.rvm/scripts/rvm
# rvm use 1.9.3-p125
echo "start run_service" >> /tmp/stockton.tmp
# /home/ub2/.rvm/scripts/rvm use 1.9.3-p125
date >> /tmp/stockton.tmp
which ruby >> /tmp/stockton.tmp
cd /media/BLinux/ub2/rex/eg323/stockton/
# echo "start bundle install" >> /tmp/stockton.tmp
# bundle install >> /tmp/stockton.tmp  # probably not needed

date >> /tmp/stockton.tmp
echo "PATH: " $PATH >> /tmp/stockton.tmp
echo "start rails runner" >> /tmp/stockton.tmp
# /media/BLinux/ub2/rex/eg323/stockton/script/rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1
# rvm wrapper ruby-1.9.3-p125@gemsetaa stockton rails
#   => /home/ub2/.rvm/bin/stockton_rails   which is just a soft link
#      to /home/ub2/.rvm/wrappers/ruby-1.9.3-p125/rails
/home/ub2/.rvm/bin/stockton_rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1
# /home/ub2/.rvm/wrappers/ruby-1.9.3-p125/rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1

# gives error:
# /media/BLinux/ub2/rex/eg323/stockton/config/boot.rb:1:in `require': no such file to load -- rubygems (LoadError)
# 	from /media/BLinux/ub2/rex/eg323/stockton/config/boot.rb:1
# 	from /media/BLinux/ub2/rex/eg323/stockton/script/rails:5:in `require'
# 	from /media/BLinux/ub2/rex/eg323/stockton/script/rails:5

# /home/ub2/.rvm/gems/ruby-1.9.3-p125/bin/rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1  # fails, Usage: rails new APP_PATH

