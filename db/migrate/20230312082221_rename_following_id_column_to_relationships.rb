class RenameFollowingIdColumnToRelationships < ActiveRecord::Migration[6.1]
  def change
    rename_column :relationships, :following_id, :followed_id
  end
end
