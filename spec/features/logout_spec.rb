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
    click_link 'Log Out'
    expect(page).to have_content 'Logged out'
  end

end
