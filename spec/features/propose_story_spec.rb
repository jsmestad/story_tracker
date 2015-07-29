require "rails_helper"

RSpec.describe "Propose New Story", type: :feature, vcr: {record: :new_episodes} do

  context 'as a viewer user' do
    it "is restricted if your not a regular user" do
      signin(as_new_user: true)
      visit '/stories/new'
      expect(page).to have_text('You do not have sufficient permissions to request stories.')
      expect(current_path).to eql('/iterations')
    end
  end

  context 'as a regular user' do
    before do
      signin(as_new_user: false, role: 'regular_user')
      visit '/stories/new'
    end

    it "filling out the form" do
      fill_in 'story_stakeholder', with: 'customer'
      fill_in 'story_the_ask', with: 'slack integration'
      fill_in 'story_reasoning', with: 'I can stop importing invoices manually'

      click_on 'Submit Story'

      expect(current_path).to eql('/iterations')

      click_on 'Your Requests'
      expect(page).to have_css('table tbody tr')
      # expect(page).to have_text('slack integration')
    end
  end
end

RSpec.describe "Propose Story Addition to Iteration", type: :feature, vcr: {record: :new_episodes} do

  context 'as a viewer user' do
    it "is restricted if your not a regular user" do
      signin(as_new_user: true)
      visit '/iterations/6/stories/new'
      expect(page).to have_text('You do not have sufficient permissions to request stories.')
      expect(current_path).to eql('/iterations')
    end
  end

  context 'as a regular user' do
    before do
      signin(as_new_user: false, role: 'regular_user')
      visit '/iterations/6/stories/new'
    end

    it "filling out the form" do
      fill_in 'story_stakeholder', with: 'customer'
      fill_in 'story_the_ask', with: 'slack integration'
      fill_in 'story_reasoning', with: 'I can stop importing invoices manually'

      click_on 'Submit Story'

      expect(current_path).to eql('/iterations')

      click_on 'Your Requests'
      expect(page).to have_css('table tbody tr')
      # expect(page).to have_text('slack integration')
    end
  end
end

