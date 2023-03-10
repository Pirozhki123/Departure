class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.references :favorite, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.references :relationship, null: false, foreign_key: true

      t.timestamps
    end
  end
end
