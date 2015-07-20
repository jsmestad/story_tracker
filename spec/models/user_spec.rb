require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryGirl.build(:user, name: 'Test User') }

  subject { user }

  it { is_expected.to have_many(:stories).dependent(:destroy) }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_presence_of(:provider) }

  it { is_expected.to validate_uniqueness_of(:uid).case_insensitive }

  it "#name returns a string" do
    expect(subject.name).to match 'Test User'
  end

  describe '#api_key' do
    before { user.api_key = 'foobar' }

    it { is_expected.to respond_to(:api_key) }
    it { is_expected.to respond_to(:api_key=) }

    it 'encrypts the key to #encrypted_api_key' do
      expect {
        user.api_key = 'changed_bar'
      }.to change(user, :encrypted_api_key)
      expect(user.api_key).to eql('changed_bar')
      expect(user.encrypted_api_key).to_not match(/changed_bar/)
    end


  end
end
