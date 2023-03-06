class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.reference :customer

      t.timestamps
    end
  end
end
