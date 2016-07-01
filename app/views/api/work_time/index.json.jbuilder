json.days @processor.with_missing_days
json.checked_out @processor.checked_out?
json.range_finished @processor.range_finished?
json.call(@processor, :left_minutes, :total_overtime, :day_ends_at)
