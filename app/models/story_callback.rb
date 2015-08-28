class StoryCallback < ActiveRecord::Base
  belongs_to :story, inverse_of: :activities

  validates_presence_of :highlight

  scope :for_today, -> {
    where('created_at >= ?', Time.now.beginning_of_day)
  }
end
