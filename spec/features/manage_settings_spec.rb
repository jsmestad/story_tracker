require 'rails_helper'

feature 'Managing a User', :omniauth, :vcr do
  let(:tracker_key) { ENV['PIVOTAL_TRACKER_API_TOKEN'] }

  scenario 'user can set their own API key' do
    signin

    visit edit_user_path
    fill_in 'Pivotal Tracker API Token', with: tracker_key
    click_on 'Update User'
    expect(page).to have_content("Account updated")
  end


  scenario 'gracefully fails over when API key is outdated' do
    user_with_badkey = FactoryGirl.create(:user, uid: '12345', provider: 'github')
    user_with_badkey.api_key = 'bad_key'
    user_with_badkey.save(validate: false)

    signin

    expect(page).to have_content('no longer works')
    expect(current_path).to eql('/user/edit')

    fill_in 'Pivotal Tracker API Token', with: tracker_key
    click_on 'Update User'

    expect(page).to have_no_content('no longer works')
    expect(current_path).to_not eql('/user/edit')
  end
end

