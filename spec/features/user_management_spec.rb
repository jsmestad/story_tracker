require 'rails_helper'

RSpec.describe "User Management", type: :feature, omniauth: true, vcr: true do
  before do
    FactoryGirl.create_list(:user, 3)
  end

  context 'as a non-admin' do
    it 'restricts regular users from viewing the page' do
      signin(as_new_user: false, role: 'regular_user')
      visit '/users'

      expect(page).to have_text('You cannot perform this action.')
      expect(current_path).to_not eql('/users')
    end

    it 'restricts regular users from viewing the page' do
      signin(as_new_user: false, role: 'viewer')
      visit '/users'

      expect(page).to have_text('You cannot perform this action.')
      expect(current_path).to_not eql('/users')
    end
  end

  context 'as an admin' do
    before do
      signin(as_new_user: false, role: 'admin')
      visit '/users'
    end

    it 'lists all the users of the system' do
      expect(page).to have_css('table.users tbody tr', count: 4)
    end

    it 'allows me to change a users role' do
      expect(page).to have_css('table.users tbody tr', count: 4)
      within('table.users') do
        find(:row, 1).click_link('Delete')
      end
      expect(page).to have_text('User has been deleted.')
      expect(page).to have_css('table.users tbody tr', count: 3)
    end
  end
end

