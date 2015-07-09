require 'rails_helper'

RSpec.describe StoryFormatter do
  it { is_expected.to validate_presence_of(:stakeholder) }
  it { is_expected.to validate_presence_of(:the_ask) }
  it { is_expected.to validate_presence_of(:reasoning) }

  it 'uses the ask for the name' do
    obj = described_class.new(the_ask: 'foo bar')
    expect(obj.name).to eql('foo bar')
  end

  it 'has a formatted description' do
    obj = described_class.new(stakeholder: 'boss', the_ask: 'another drink', reasoning: 'I get drunk')
    expect(obj.description).to eql('As an boss, I want another drink, so that I get drunk.')
  end

  describe '#as_params' do
    it 'returns all the expected keys' do
      obj = described_class.new
      expect(obj.as_params).to have_key(:description)
      expect(obj.as_params).to have_key(:name)
      expect(obj.as_params).to_not have_key(:after_id)

      obj.after_id = 2
      expect(obj.as_params).to have_key(:after_id)
    end
  end
end
