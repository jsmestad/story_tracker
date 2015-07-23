FactoryGirl.define do
  factory :story do

    trait :with_user do
      user
    end
  end
end
