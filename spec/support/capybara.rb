require 'capybara/rails'
require 'capybara/rspec'

Capybara.add_selector(:row) do
  xpath { |num| ".//tbody/tr[#{num}]" }
end

Capybara.add_selector(:alt_button) do
  xpath { |word| "//button[@alt='#{word}']" }
end
