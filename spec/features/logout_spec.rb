require 'rails_helper'

# Feature: Log out
#   As a user
#   I want to sign out
#   So I can protect my account from unauthorized access
feature 'Log out', :omniauth, :vcr do

  # Scenario: User signs out successfully
  #   Given I am signed in
  #   When I sign out
  #   Then I see a signed out message
  scenario 'user logs out successfully' do
    signin
    main_menu.click
    click_link 'Log out'
    main_menu.click
    expect(page).to have_link('Log in')
    expect(page).to have_no_link('Log out')
    # expect(page).to have_content 'Logged out'
  end

end
