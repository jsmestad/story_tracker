class AddEstimateToStories < ActiveRecord::Migration
  def change
    add_column :stories, :estimate, :integer, null: true, limit: 1 # Max Value 127
  end
end
