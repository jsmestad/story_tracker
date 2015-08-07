# StoryTracker

This web application serves the non-engineers looking to interface with a team
that utilizes Pivotal Tracker as their development tool.


## Configuration

See the `.env.template` for ENV values that must be set. Please use your best
cryptographic judgment when it comes to generating values for these keys. The
provided values should never be used and are there as contrived examples only.

## Hosting

This application is built to run on Heroku out of the box with Airbrake
handling any errors that come up. If your goal is to host elsewhere, you can
remove a few of the included items:

```ruby
# Remove from `Gemfile`

gem 'rails_12factor'
gem 'puma'
gem 'airbrake'
gem 'skylight'
```

Remove/Modify the `config/environments/production.rb` file's ActionMailer
settings:

```ruby
  # Configure SendGrid for use with Heroku
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
```

Remove `config/initializers/airbrake.rb`, `config/puma.rb` and `Procfile` as
they are unnecessary.

## Security

By the nature of StoryTracker, you are granting this application read/write
permissions to a PivotalTracker project. We highly recommend you try this out
with a sample project while getting familiar with how this application
functions.

This application uses Github logins as it's authentication mechanism. Setting
the `ORGNAME` ENV var will restrict account authorization to those with access
to that Github organization.

## Getting Started

The quickest way to get this going on a local machine is:

```
git clone git://github.com/jsmestad/story_tracker.git
cd story_tracker
cp config/database.example.yml config/database.yml
touch .env
bundle install
rake db:create db:migrate
rails server
```

To add your first administrator, this must be done via Rails console. After
logging into the application (creating your account) open a rails console and
enter:

```ruby
user = User.first
user.admin!
```

Please see the Security section as the `.env` file is not set up. Use
`.env.template` as a guide for what values must be set.

## License

Please see [LICENSE](https://github.com/jsmestad/story_tracker/blob/master/LICENSE) for
licensing details.

## Author

Justin Smestad, [@jsmestad](https://twitter.com/jsmestad)

