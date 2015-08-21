require 'rails_helper'

RSpec.describe StoryCallback, type: :model do
  it { is_expected.to belong_to(:story) }

  it { is_expected.to validate_presence_of(:highlight) }
end
