source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.3'
gem 'pg', '>= 0.18'
gem 'pg_search', '>= 1.0.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'rack-cors', require: 'rack/cors'

gem 'jquery-rails'
# gem 'turbolinks'

gem 'tracker_api', '~> 0.2.10', github: 'jsmestad/tracker_api', branch: 'feature/configure-client'
gem 'haml-rails'
gem 'simple_form'
gem 'acts_as_follower', '>= 0.2.1'

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
gem 'faraday_middleware'

gem 'jsonapi-resources', '~> 0.6.1'
gem 'active_model_serializers', '~> 0.10.0.rc2'
gem 'responders', '~> 2.0'

gem 'high_voltage', '~> 2.4.0'
gem 'markdown-rails'
gem 'redcarpet'

gem 'activeadmin', '~> 1.0.0.pre2'
gem 'paper_trail', '~> 4.0.0'

group :development do
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-pow', require: false
  gem 'guard-rails', require: false
  gem 'pry-remote'
end

group :development, :test do
  gem 'faraday-detailed_logger'
  gem 'byebug'
  gem 'quiet_assets'

  gem 'web-console', '~> 2.0'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'ffaker'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-its'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'dalli'
  gem 'puma'
  gem 'rails_12factor'
end
