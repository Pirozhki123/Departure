class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
#      t.references :customer, null: false, foreign_key: true
      t.bigint :customer_id, null: false
      t.references :post, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
