class AddStoryTypeToStories < ActiveRecord::Migration
  def change
    add_column :stories, :story_type, :string, null: false, default: 'feature'
    add_index :stories, :story_type, where: "story_type = 'feature'", name: 'is_feature'
    add_index :stories, :story_type, where: "story_type = 'defect'", name: 'is_defect'
  end
end
