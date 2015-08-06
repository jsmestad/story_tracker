require 'rails_helper'

feature 'Managing a User', :omniauth, :vcr do
  let(:tracker_key) { ENV['PIVOTAL_TRACKER_API_TOKEN'] }
  let(:email) { 'foo@example.local' }

  scenario 'user can set their own API key and Email Address' do
    signin(as_new_user: false, role: 'regular_user')

    click_on 'Edit Account Settings'
    fill_in 'Pivotal Tracker API Token', with: tracker_key
    fill_in 'Email Address', with: email
    click_on 'Update Account'
    expect(page).to have_content("Account updated")

    click_on 'Edit Account Settings'
    expect(page).to have_field('Pivotal Tracker API Token', with: tracker_key)
    expect(page).to have_field('Email Address', with: email)
  end


  scenario 'gracefully fails over when API key is outdated' do
    user_with_badkey = FactoryGirl.create(:user, :regular_user, uid: '12345', provider: 'github', email_address: 'foo@example.local')
    user_with_badkey.api_key = 'bad_key'
    user_with_badkey.save(validate: false)

    signin

    expect(page).to have_content('no longer works')

    fill_in 'Pivotal Tracker API Token', with: tracker_key
    click_on 'Update Account'

    expect(page).to have_no_content('no longer works')
  end
end

