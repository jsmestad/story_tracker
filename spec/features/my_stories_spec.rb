require 'rails_helper'

RSpec.describe 'Viewing Stories', type: :feature do
  let!(:my_user) { FactoryGirl.create(:user, :regular_user) }

  context 'filtering stories' do
    before do
      FactoryGirl.create(:story, user: my_user)
      FactoryGirl.create(:story, :as_rejected, user: my_user)
      FactoryGirl.create(:story, :as_completed, user: my_user)
      followed_story = FactoryGirl.create(:full_story, :as_approved)
      my_user.follow(followed_story)

      signin(as_user: my_user) #as_new_user: false)
    end

    it 'shows all by default' do
      visit '/account'

      expect(page).to have_css('.story', count: 4)
    end

    it 'shows approved if selected' do
      visit '/account'
      click_on 'Approved'
      expect(page).to have_css('.story', count: 1)
      within('.story') do
        expect(page).to have_text('Approved')
      end
    end

    it 'shows submitted if selected' do
      visit '/account'
      click_on 'Pending'
      expect(page).to have_css('.story', count: 1)
      within('.story') do
        expect(page).to have_link('Modify')
      end
    end

    it 'shows rejected if selected' do
      visit '/account'
      click_on 'Rejected'
      expect(page).to have_css('.story', count: 1)
      within('.story') do
        expect(page).to have_text('Rejected')
      end
    end

    it 'shows completed if selected' do
      visit '/account'
      click_on 'Completed'
      expect(page).to have_css('.story', count: 1)
      within('.story') do
        expect(page).to have_text('Completed')
      end
    end
  end
end
