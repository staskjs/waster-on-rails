class Interval < ActiveRecord::Base
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

  # Determine if in and out days are different
  # In other words if user checked in on one day
  # and checked out on another
  def different_days
    time_out.present? && time_in.to_date != time_out.to_date
  end

  def to_builder
    Jbuilder.new do |interval|
      interval.call(self, :id, :time_in, :time_out, :different_days)
    end
  end

end
