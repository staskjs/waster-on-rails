class WorkDay < Hash
  include Hashie::Extensions::MergeInitializer
  include Hashie::Extensions::MethodAccess

  # Update last interval with time_out
  def check_out
    intervals.last.update_attributes(time_out: Time.now)
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
end
