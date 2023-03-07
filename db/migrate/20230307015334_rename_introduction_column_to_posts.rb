class RenameIntroductionColumnToPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :Introduction, :introduction
  end
end
