class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
#      t.references :customer, null: false, foreign_key: true
      t.bigint :customer_id, null: false

      t.timestamps
    end
  end
end
