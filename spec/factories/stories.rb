FactoryGirl.define do
  factory :story do

    trait :with_user do
      user
    end

    trait :with_user_and_email do
      association :user, factory: :user, email_address: 'foo@example.com'
    end
  end
end
