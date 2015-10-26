FactoryGirl.define do
  factory :story do
    name 'As a customer, I want foo bar'
    description 'As an boss, I want another drink, so that I get drunk'
    story_type 'feature'

    factory :full_story, traits: [:with_user]

    trait :as_approved do
      after(:create) do |obj|
        obj.state = :approved
        obj.external_ref ||= '100879128'
        obj.save(validate: false)
      end
    end

    trait :as_rejected do
      after(:create) do |obj|
        obj.reject!
      end
    end

    trait :as_completed do
      after(:create) do |obj|
        obj.state = :completed
        obj.external_ref ||= '100879128'
        obj.save(validate: false)
      end
    end

    trait :with_user do
      user
    end

    trait :with_user_and_email do
      association :user, factory: :user, email_address: 'foo@example.com'
    end

    trait :with_activity do
      after(:create) do |obj|
        FactoryGirl.create_list(:activity, 4, story: obj)
      end
    end
  end
end
