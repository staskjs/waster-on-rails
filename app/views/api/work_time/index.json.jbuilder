json.days @processor.with_missing_days
json.checked_out @processor.checked_out?
json.call(@processor, :left_minutes, :total_overtime)
