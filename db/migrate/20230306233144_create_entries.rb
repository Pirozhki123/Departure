class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
#      t.references :customer, null: false, foreign_key: true
      t.bigint :customer_id, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
