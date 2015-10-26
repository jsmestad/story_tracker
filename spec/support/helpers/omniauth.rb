module Omniauth

  module Mock
    def auth_mock(uid='12345')
      OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => uid,
        'info' => {
          'nickname' => 'foo_mockuser'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end
  end

  module SessionHelpers
    def main_menu
      page.find(:xpath, "//a[@class='cd-secondary-nav-trigger']")
    end

    def signin(as_new_user: true, role: 'regular_user', as_user: nil)
      visit root_path
      if !!as_new_user and as_user.blank?
        as_user = FactoryGirl.create(:user, role: role)
      end
      auth_mock(as_user.uid)
      main_menu.click
      click_link "Log in"
    end
  end

end
