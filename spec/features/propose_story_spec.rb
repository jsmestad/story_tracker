require "rails_helper"

RSpec.describe "Propose New Story", type: :feature, vcr: {record: :new_episodes} do

  before do
    signin
    visit '/stories/new'
  end

  it "filling out the form" do
    fill_in 'story_stakeholder', with: 'customer'
    fill_in 'story_the_ask', with: 'slack integration'
    fill_in 'story_reasoning', with: 'I can stop importing invoices manually'

    click_on 'Propose Story'

    expect(current_path).to eql('/iterations')
    # expect(page).to have_text('slack integration')
  end
end

