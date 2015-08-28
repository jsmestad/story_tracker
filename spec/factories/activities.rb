FactoryGirl.define do
  factory :activity, class: StoryCallback do
    highlight { ['added', 'started', 'estimated', 'deleted', 'moved and scheduled'].sample }
  end
end
