class CreateWorkTimes < ActiveRecord::Migration
  def change
    create_table :work_times do |t|
      t.datetime :time_in
      t.datetime :time_out
      t.integer :user_id
    end
  end
end
