require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryGirl.build(:user, name: 'Test User') }

  subject { user }

  it { is_expected.to have_many(:stories).dependent(:destroy) }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_presence_of(:provider) }

  it { is_expected.to validate_uniqueness_of(:uid).case_insensitive }

  describe "#create" do
    it "generates a token" do
      user = FactoryGirl.create(:user)

      expect(user.token.length).to eq 22
    end
  end

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

  describe 'email address' do
    it { is_expected.to allow_value("country-code-tld@sld.rw").for(:email_address) }
    it { is_expected.to_not allow_value("another-invalid-ip@127.0.0.256").for(:email_address) }

    it 'has a flag that can check for email address' do
      expect {
        user.email_address = 'foo@example.com'
      }.to change(user, :has_email_address?).from(false).to(true)
    end
  end

  describe 'roles' do
    it 'defaults to viewer role' do
      new_user = described_class.new
      expect(new_user.role).to eql('viewer')
      expect(new_user.viewer?).to eql(true)
    end

    it 'supports a "regular_user" role' do
      new_user = FactoryGirl.build(:user)
      expect {
        new_user.regular_user!
      }.to change(new_user, :regular_user?).from(false).to(true)
    end

    it 'supports a "admin" role' do
      new_user = FactoryGirl.build(:user)
      expect {
        new_user.admin!
      }.to change(new_user, :admin?).from(false).to(true)
    end
  end

end
