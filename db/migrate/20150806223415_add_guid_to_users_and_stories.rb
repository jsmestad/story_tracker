class AddGuidToUsersAndStories < ActiveRecord::Migration
  def up
    execute 'create extension "uuid-ossp"'
    add_column :users, :guid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_column :stories, :guid, :uuid, null: false, default: 'uuid_generate_v4()'

    add_index :users, :guid, unique: true
    add_index :stories, :guid, unique: true
  end

  def down
    remove_column :users, :guid, :uuid
    remove_column :stories, :guid, :uuid

    execute 'drop extension "uuid-ossp"'
  end
end
