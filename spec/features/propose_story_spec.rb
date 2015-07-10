require "rails_helper"

feature "Propose New Story" do

  background do
    visit '/stories/new'
  end

  scenario "filling out the form" do
    fill_in 'story_stakeholder', with: 'customer'
    fill_in 'story_the_ask', with: 'slack integration'
    fill_in 'story_reasoning', with: 'I can stop importing invoices manually'

    click_on 'Propose Story'

    expect(current_path).to eql('/iterations')
    expect(page).to have_text('slack integration')
  end
end
