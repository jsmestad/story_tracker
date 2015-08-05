require 'rails_helper'

RSpec.describe DefectFormatter do
  # it { is_expected.to validate_presence_of(:stakeholder) }
  # it { is_expected.to validate_presence_of(:the_ask) }
  # it { is_expected.to validate_presence_of(:reasoning) }

  # it 'uses the ask and stakeholder for the name' do
    # obj = described_class.new(stakeholder: 'customer', the_ask: 'foo bar')
    # expect(obj.name).to eql('As a customer, I want foo bar')
  # end

  # it 'has a formatted description' do
    # obj = described_class.new(stakeholder: 'boss', the_ask: 'another drink', reasoning: 'I get drunk')
    # expect(obj.description).to eql('As an boss, I want another drink, so that I get drunk.')
  # end

  # describe '#body' do
    # it 'contains the error expectation information' do
      # obj = described_class.new(error_expectation: 'try again', confirmation_flow: 'see it again')
      # expect(obj.body).to match(/\* try again/)
      # expect(obj.body).to match(/\* see it again/)
      # expect(obj.as_params[:description]).to match(/\* try again/)
      # expect(obj.as_params[:description]).to match(/\* see it again/)
    # end
  # end

  describe '#as_params' do
    it 'returns all the expected keys' do
      obj = described_class.new
      expect(obj.as_params).to have_key(:description)
      expect(obj.as_params).to have_key(:name)
      expect(obj.as_params[:story_type]).to eql('bug')
    end
  end
end
