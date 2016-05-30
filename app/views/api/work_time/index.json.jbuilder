json.days @processor.with_missing_days
json.call(@processor, :left_minutes, :total_overtime)
