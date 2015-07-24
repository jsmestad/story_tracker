FactoryGirl.define do
  factory :user do
    name 'John Doe'
    sequence :uid do |n|
      "uid_#{n}"
    end
    provider 'github'

    trait :with_email do
      email_address 'foo@example.com'
    end
  end
end
