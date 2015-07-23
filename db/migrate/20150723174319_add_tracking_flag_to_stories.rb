class AddTrackingFlagToStories < ActiveRecord::Migration
  def change
    add_column :stories, :subscribe, :boolean, default: true, null: false
  end
end
