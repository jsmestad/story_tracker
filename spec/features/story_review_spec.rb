require 'rails_helper'

RSpec.describe 'Story review process', feature: :feature, omniauth: true, vcr: true do
  before do
    FactoryGirl.create_list(:full_story, 2)
    FactoryGirl.create_list(:full_story, 1, :as_approved)
    FactoryGirl.create_list(:full_story, 1, :as_rejected)
  end

  context 'as a non-admin' do
    it 'restricts regular users from viewing the page' do
      signin(as_new_user: false, role: 'regular_user')
      visit '/stories'

      expect(page).to have_text('You cannot perform this action.')
      expect(current_path).to_not eql('/stories')
    end

    it 'restricts regular users from viewing the page' do
      signin(as_new_user: false, role: 'viewer')
      visit '/stories'

      expect(page).to have_text('You cannot perform this action.')
      expect(current_path).to_not eql('/stories')
    end
  end

  context 'as an admin' do
    before do
      signin(as_new_user: false, role: 'admin')
      visit '/stories'
    end

    it 'lists all the submitted stories in the system' do
      expect(page).to have_css('.stories .story', count: 2)
    end
  end
end
