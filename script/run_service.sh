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
# /home/ub2/.rvm/scripts/rvm use 1.9.3-p125

/media/BLinux/ub2/rex/eg323/stockton/script/rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1

# /home/ub2/.rvm/gems/ruby-1.9.3-p125/bin/rails runner -e development "StockService.fake_request" >> /tmp/stockton.tmp 2>&1  # fails, Usage: rails new APP_PATH

