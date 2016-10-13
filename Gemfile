source 'https://rubygems.org'

### BASICS

# Ruby version
ruby '2.3.1'
# Rails version
gem 'rails', '~> 4'
# Use postgres as database
gem 'pg'
# For Travis CI
gem 'rake', group: :test

### END BASICS

### VIEWS, ASSETS, FRONTEND STUFF

# HAML makes your life easier
gem 'haml'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use jQuery
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Use Bootstrap, the CSS framework (getbootstrap.com)
gem 'bootstrap-sass'
# Javascript interpreter
gem 'therubyracer', platforms: :ruby
# Adds attachments, in the form of long submissions
gem 'paperclip'
# Adds nested forms
gem 'nested_form'
# Markdown parser
gem 'redcarpet'
# Zip submissions
gem 'rubyzip'
# Autoprefixer for SCSS
gem 'autoprefixer-rails'
# Inline SVG
gem 'inline_svg'

group :development do
  # Favicon set
  gem 'rails_real_favicon'
end

### END ASSETS

### UTILITIES

# Schema Validations: to maintin referential integrity in database and models
gem 'schema_validations', group: [:development, :test] # production :(
# Add time validations
gem 'validates_timeliness'
# Allows more complex SQL queries
gem 'squeel'
# Adds delayed job queueing for jobs that are executed in the future
gem 'delayed_job_active_record'
# Do not generate digests for error pages
gem 'non-stupid-digest-assets'
# Add pagination
gem 'will_paginate', github: 'jonatack/will_paginate'
# Generate PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
# Test coverage
gem 'simplecov', require: false, group: :test

group :development do
  # Annotates model with schema
  gem 'annotate'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Shoot those n+1 queries!
  gem 'bullet'
  # Trace routes
  gem 'traceroute'
  # ?
  gem 'table_flipper'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug'
  # Factory girl: factories for testing
  gem 'factory_girl_rails'
  # Environment variables for local machine
  gem 'dotenv-rails', require: 'dotenv/rails-now'
end

group :production do
  # Adds daemons for DelayedJob
  gem 'daemons'
  # Email with Mailgun
  gem 'rest-client'
  # API for LINE bot
  gem 'line-bot-api'
end

### END UTILITIES

### MAINTENANCE

# Model logging
gem 'paper_trail'

group :development, :production do
  # Add browser info in logs
  gem 'browser_details'
  # Database profiler
  gem 'rack-mini-profiler', require: false
  # Profiler
  gem 'newrelic_rpm'
  # Auto-email exceptions
  gem 'exception_notification'
end

group :production do
  # Sitemap generator
  gem 'sitemap_generator'
end

### END MAINTENANCE

### SECURITY

# Adds roles
gem 'rolify'
# Adds privileges
gem 'cancancan'
# Adds various security stuff. You need protection!
gem 'rack-protection'
# Adds hashes for passwords.
gem 'bcrypt'

group :development, :production do
  # A recaptcha helper gem.
  gem 'recaptcha', require: 'recaptcha/rails'
end

group :development do
  # Security checkup
  gem 'brakeman'
end

### END SECURITY

### PRODUCTION STUFF

group :production do
  # Use unicorn as the web server.
  gem 'unicorn'
  # This gem kills unicorn workers after certain time to prevent memory
  # leakage.
  gem 'unicorn-worker-killer'
end

group :development do
  # Use capistrano and its extensions.
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm', github: 'capistrano/rvm'
  gem 'capistrano3-delayed-job'
end

### END PRODUCTION STUFF
