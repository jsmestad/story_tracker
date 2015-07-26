module Omniauth

  module Mock
    def auth_mock
      OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '12345',
        'user_info' => {
          'name' => 'mockuser'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end
  end

  module SessionHelpers
    def signin
      visit root_path
      expect(page).to have_content("Log In")
      auth_mock
      click_link "Log In"
    end
  end

end
