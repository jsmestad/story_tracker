FactoryGirl.define do
  factory :user do
    name 'John Doe'
    sequence :uid do |n|
      "uid_#{n}"
    end
    provider 'github'
  end
end
