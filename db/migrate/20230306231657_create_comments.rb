class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.reference :customer
      t.reference :post
      t.string :body

      t.timestamps
    end
  end
end
