class WorkTime < ActiveRecord::Base
  attr_reader :minutes_worked

  def get
  end

  def finished?
    time_out.present?
  end

  def minutes_worked
    if finished?
      TimeDifference.between(time_in, time_out).in_minutes.floor
    else
      TimeDifference.between(time_in, Time.current).in_minutes.floor
    end
  end

  def day
    time_in.wday
  end
end
