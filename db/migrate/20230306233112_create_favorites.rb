class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
#      t.references :customer, null: false, foreign_key: true
      t.bigint :customer_id, null: false
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
