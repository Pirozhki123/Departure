class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.reference :customer
      t.reference :room
      t.text :body

      t.timestamps
    end
  end
end
