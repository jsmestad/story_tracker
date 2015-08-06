FactoryGirl.define do
  factory :user do
    name 'John Doe'
    uid { SecureRandom.uuid }
    provider 'github'
    username { FFaker::Internet.user_name }

    trait :with_email do
      email_address 'foo@example.com'
    end

    trait :regular_user do
      role 'regular_user'
    end

    trait :admin do
      role 'admin'
    end
  end
end
