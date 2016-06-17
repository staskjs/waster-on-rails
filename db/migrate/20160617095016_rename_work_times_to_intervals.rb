class RenameWorkTimesToIntervals < ActiveRecord::Migration
  def change
    rename_table :work_times, :intervals
  end
end
