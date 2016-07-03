class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_hours, :float
    add_column :users, :days_off, :string
  end
end
