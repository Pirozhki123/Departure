class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.reference :favorite
      t.reference :comment
      t.reference :relationship

      t.timestamps
    end
  end
end
