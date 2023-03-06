class AddPrivateToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :private, :boolean, default: false
  end
end
