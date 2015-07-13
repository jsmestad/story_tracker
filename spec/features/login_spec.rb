require 'rails_helper'

# Feature: Log in
#   As a user
#   I want to log in
#   So I can visit protected areas of the site
feature 'Log in', :omniauth, :vcr do

  # Scenario: User can logged in with valid account
  #   Given I have a valid account
  #   And I am not logged in
  #   When I log in
  #   Then I see a success message
  scenario "user can log in with valid account" do
    signin
    expect(page).to have_content("Log out")
  end

  # Scenario: User cannot log in with invalid account
  #   Given I have no account
  #   And I am not logged in
  #   When I log in
  #   Then I see an authentication error message
  scenario 'user cannot sign in with invalid account' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    visit root_path
    expect(page).to have_content("Log in")
    click_link "Log in"
    expect(page).to have_content('Authentication error')
  end

end
