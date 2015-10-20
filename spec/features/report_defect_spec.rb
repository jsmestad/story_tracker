require "rails_helper"

RSpec.describe "Report Defect", type: :feature, vcr: {record: :new_episodes} do

  context 'as a viewer user' do
    it "is restricted if your not a regular user" do
      signin(as_new_user: true)
      visit '/defects/new'
      expect(page).to have_text('You do not have sufficient permissions to report defects.')
      expect(current_path).to eql('/iterations')
    end
  end

  context 'as a regular user' do
    before do
      signin(as_new_user: false, role: 'regular_user')
      visit '/defects/new'
    end

    it "filling out the form" do
      fill_in 'defect_assumption', with: 'customer'
      fill_in 'defect_actual', with: 'slack integration'
      # fill_in 'story_reasoning', with: 'I can stop importing invoices manually'
      select 'No', from: 'defect_workaround'

      find(:alt_button, 'File Report').click

      expect(current_path).to eql('/iterations')

      main_menu.click
      click_on 'Your Requests'
      expect(page).to have_css('.stories .story')
      # expect(page).to have_text('slack integration')
    end
  end
end

