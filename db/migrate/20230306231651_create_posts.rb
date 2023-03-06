class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.reference :customer
      t.reference :place
      t.string :Introduction

      t.timestamps
    end
  end
end
