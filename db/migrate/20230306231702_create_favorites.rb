class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.reference :customer
      t.reference :post

      t.timestamps
    end
  end
end
