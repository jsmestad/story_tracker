FactoryGirl.define do
  factory :move_payload, class: WebhookPayload do
    skip_create
    initialize_with do
      file = File.read(Rails.root.join('spec/fixtures/activity_payloads/story_move_activity.json'))
      new(JSON.parse(file))
    end
  end
  factory :estimated_payload, class: WebhookPayload do
    skip_create
    initialize_with do
      file = File.read(Rails.root.join('spec/fixtures/activity_payloads/story_estimated_activity.json'))
      new(JSON.parse(file))
    end
  end
  factory :delete_payload, class: WebhookPayload do
    skip_create
    initialize_with do
      file = File.read(Rails.root.join('spec/fixtures/activity_payloads/story_delete_activity.json'))
      new(JSON.parse(file))
    end
  end
  factory :start_payload, class: WebhookPayload do
    skip_create
    initialize_with do
      file = File.read(Rails.root.join('spec/fixtures/activity_payloads/story_started_activity.json'))
      new(JSON.parse(file))
    end
  end
end
