class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
#      t.references :customer, null: false, foreign_key: true
      t.bigint :customer_id, null: false
      t.references :place, null: false, foreign_key: true
      t.string :Introduction

      t.timestamps
    end
  end
end
