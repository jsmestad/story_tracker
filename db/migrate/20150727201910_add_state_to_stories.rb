class AddStateToStories < ActiveRecord::Migration
  def change
    add_column :stories, :state, :integer, default: 0, null: false
  end
end
