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
end
