class AddStoryDetailsToStories < ActiveRecord::Migration
  def change
    change_table :stories do |t|
      t.string :name
      t.string :after_id
      t.text :description
    end
  end
end
