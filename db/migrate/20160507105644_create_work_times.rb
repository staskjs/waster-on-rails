class CreateWorkTimes < ActiveRecord::Migration
  def change
    create_table :work_times do |t|
      t.datetime :time_in
      t.datetime :time_out
      t.string :user_id
    end
  end
end
