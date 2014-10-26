source 'https://rubygems.org'

ruby '2.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

gem 'rack-cors', :require => 'rack/cors'
gem 'rack-cache'

# Use Heroku 12 Factor app for Heroku support
gem 'rails_12factor', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'compass'

gem 'mongoid', '~> 4.0.0'
gem "mongoid_slug"

gem 'bootstrap-sass'
gem 'simple_form', github: 'plataformatec/simple_form'

gem 'smarter_csv'

gem 'angular_rails_csrf'
gem 'devise'

gem 'newrelic_rpm'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-timepicker-rails'

gem 'mandrill-api'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
   gem 'heroku-deflater'
end

group :development, :test do
  gem 'pry'
  gem 'letter_opener'
end

group :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'factory_girl_rails'
  gem "database_cleaner"
end
