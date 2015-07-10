source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.3'
gem 'pg', '>= 0.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'

gem 'tracker_api', '~> 0.2.10', github: 'jsmestad/tracker_api', branch: 'verify-object-ext-is-needed'
gem 'haml-rails'
gem 'simple_form'

gem 'neat'
gem 'bourbon'

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
  gem 'shoulda-matchers'
  gem 'vcr'
end

group :production do
  gem 'rails_12factor'
end
