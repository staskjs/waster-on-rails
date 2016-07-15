class AddDefaultToDaysOff < ActiveRecord::Migration
  def up
    change_column_default :users, :days_off, '0,6'
  end

  def down
    change_column_default :users, :days_off, nil
  end
end
