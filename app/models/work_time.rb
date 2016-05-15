class WorkTime < ActiveRecord::Base
  attr_reader :minutes_worked

  def get
  end

  def finished?
    time_out.present?
  end

  def minutes_worked
    if finished?
      TimeDifference.between(time_in, time_out).in_minutes
    else
      TimeDifference.between(time_in, Time.current).in_minutes
    end
  end

  def day
    time_in.wday
  end

  # Amount of minutes that should be worked in this day
  #
  def minutes_to_work
    WorkTimeProcessor.get_minutes_in_day(time_in)
  end
end
