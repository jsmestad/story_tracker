class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_api_key, :string
  end
end
