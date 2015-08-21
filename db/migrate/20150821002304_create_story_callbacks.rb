class CreateStoryCallbacks < ActiveRecord::Migration
  def change
    create_table :story_callbacks do |t|
      t.integer :story_id, null: false
      t.string :highlight, null: false

      t.timestamps null: false
    end

    add_index :story_callbacks, :story_id
  end
end
