source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.8'
# Use cancancan for authorization
gem 'cancancan', '~> 3.6.1'
gem 'chartkick', '=5.0.7'
gem 'groupdate', '=6.4.0'
# Use sqlite3 as the database for Active Record
gem 'bootstrap_form', '~> 5.4'
gem 'bootstrap', '~> 5.3.3'

gem 'select2-rails', '=4.0.13'
gem 'whenever', require: false

gem 'aasm', '~> 5.3.1'
gem 'delayed_job_active_record'
gem 'delayed_job'
gem 'daemons'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'searchkick'
gem 'will_paginate-bootstrap', '~> 1.0'

gem 'devise', '=4.9.4'
gem 'acts_as_tenant', '~> 1.0.1'
gem 'mysql2', '=0.5.6'
gem 'will_paginate', '~> 3.3.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
gem 'pry', '=0.13.1'
gem 'pry-rails', '=0.3.9'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '=6.4.3'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rspec-rails', '~> 5.0'
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rails_real_favicon', '~> 0.1.1'

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
