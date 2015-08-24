source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.3'
gem 'pg', '>= 0.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
# gem 'turbolinks'

gem 'tracker_api', '~> 0.2.10', github: 'jsmestad/tracker_api', branch: 'feature/configure-client'
gem 'haml-rails'
gem 'simple_form'

gem 'attr_encrypted'
gem 'activerecord-session_store'
gem 'pundit', '~> 1.0.1'

gem 'neat'
gem 'bourbon'
gem 'foundation-icons-sass-rails'

gem 'airbrake'
gem 'omniauth-github', '~> 1.1.2'
gem 'octokit'

gem 'email_validator'
gem 'aasm'
gem 'pry-rails'
gem 'premailer-rails'
gem 'nokogiri' # required by premailer-rails, but not listed.
gem 'skylight'
gem 'faraday-http-cache'

gem 'high_voltage', '~> 2.4.0'
gem 'markdown-rails'
gem 'redcarpet'

group :development do
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-pow', require: false
  gem 'guard-rails', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'quiet_assets'

  gem 'web-console', '~> 2.0'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'dotenv-rails'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-its'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
  gem 'ffaker'
end

group :production do
  gem 'dalli'
  gem 'puma'
  gem 'rails_12factor'
end
