# json.days @processor.with_missing_days
json.days @processor.with_missing_days do |day|
  json.merge! day
  json.intervals day.intervals do |interval|
    json.merge! interval.to_builder.attributes!
  end
end
json.checked_out @processor.checked_out?
json.range_finished @processor.range_finished?
json.range_begin @processor.date_range.begin
json.range_end @processor.date_range.end
json.call(@processor, :left_minutes, :total_overtime, :day_ends_at, :time_frame)
