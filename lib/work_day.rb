class WorkDay < Hash
  include Hashie::Extensions::MergeInitializer
  include Hashie::Extensions::MethodAccess

  # Update last interval with time_out
  def check_out
    intervals.last.update_attributes(time_out: Time.current)
  end

  # Overtime with sign
  # If day is not finished, overtime is not calculated
  def overtime
    if is_finished
      is_overtime ? overtime_minutes : -overtime_minutes
    else
      0
    end
  end

  # Check if given interval is the latest in this day's intervals
  #
  # @param interval - interval to check
  def is_interval_latest?(interval)
    found = intervals.find { |i| i.id == interval.id }
    found.present? && found.id == intervals.last.id
  end
end
