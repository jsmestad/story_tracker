require 'capybara/rails'
require 'capybara/rspec'

Capybara.add_selector(:row) do
  xpath { |num| ".//tbody/tr[#{num}]" }
end
