require "rails_helper"

RSpec.describe "Propose New Story", type: :feature, vcr: {record: :new_episodes} do

  context 'as a viewer user' do
    it "is restricted if your not a regular user" do
      signin(as_new_user: true, role: 'viewer')
      visit '/stories/new'
      expect(page).to have_text('You do not have sufficient permissions to request stories.')
      expect(current_path).to eql('/iterations')
    end
  end

  context 'as a regular user' do
    before do
      # FactoryGirl.create(:user, :with_email, :admin)
      signin(as_new_user: true, role: 'regular_user')
      visit '/stories/new'
    end

    it "filling out the form" do
      fill_in 'story_stakeholder', with: 'customer'
      fill_in 'story_the_ask', with: 'slack integration'
      fill_in 'story_reasoning', with: 'I can stop importing invoices manually'

      find(:alt_button, 'Submit Request').click

      expect(current_path).to eql('/iterations')

      main_menu.click
      click_on 'Your Requests'
      expect(page).to have_css('.stories .story')
      expect(page).to have_css(".story[data-state='submitted']")
    end

    it 'can be viewed after creation' do
      story = FactoryGirl.create(:full_story)

      visit story_path(story)
      expect(page).to have_text(story.name)
      # expect(page).to have_text(story.description)
    end
  end
end

