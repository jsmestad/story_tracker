class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :user_id, null: false
      t.string :external_ref
      t.timestamps
    end

    add_index :stories, :user_id
  end
end
