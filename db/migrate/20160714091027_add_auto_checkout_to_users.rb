class AddAutoCheckoutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auto_checkout, :boolean, default: true
  end
end
