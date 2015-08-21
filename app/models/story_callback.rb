class StoryCallback < ActiveRecord::Base
  belongs_to :story, inverse_of: :activities

  validates_presence_of :highlight
end
