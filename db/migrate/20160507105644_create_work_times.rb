class CreateWorkTimes < ActiveRecord::Migration
  def change
    create_table :work_times do |t|
      t.datetime :date
      t.string :direction
      t.string :user_id
    end
  end
end
