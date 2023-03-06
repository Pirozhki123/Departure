class CreateTagRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_relations do |t|
      t.reference :post
      t.reference :tag

      t.timestamps
    end
  end
end
