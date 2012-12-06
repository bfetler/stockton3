source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3', '1.3.6'
end

group :production do
  gem 'pg'    # '0.14.0' in local gems dir, but heroku uses ?
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'launchy', '2.1.0'
  gem 'rspec-rails', '2.11.0'
  gem 'factory_girl_rails', '3.5.0'
# gem 'cucumber-rails'
# gem 'cucumber-rails-training-wheels'
# gem 'database_cleaner'
  gem 'webmock', '1.8.9'  # disables all http requests by default, see specs
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', '0.10.1'  # needed for coffee-rails, uglifier
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', '2.0.2'

gem 'haml-rails', '0.3.4'

gem 'devise', '1.4.2'

gem 'delayed_job_active_record', '0.3.2'

gem 'girl_friday', '0.11.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
