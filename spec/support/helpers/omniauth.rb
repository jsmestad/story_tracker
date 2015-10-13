module Omniauth

  module Mock
    def auth_mock
      OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '12345',
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

    def signin(as_new_user: true, role: 'regular_user')
      visit root_path
      unless as_new_user
        FactoryGirl.create(:user, uid: '12345', provider: 'github', role: role)
      end
      auth_mock
      main_menu.click
      click_link "Log in"
    end
  end

end
