class AddCommentFieldToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :comment, :text
  end
end
