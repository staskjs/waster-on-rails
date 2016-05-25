class WorkTimeProcessor
  attr_reader :username
  attr_reader :days_off
  attr_reader :daily_hours
  attr_reader :days
  attr_reader :left_minutes
  attr_reader :total_overtime


  def initialize(username, date = nil, time_frame = 'week', count_last = 1)
    @username = username
    @days_off = [0, 6]
    @daily_hours = 8.5

    @date = date
    @time_frame = time_frame

    # Get statistics for selected user since the beginning of selected date
    # for selected time frame (week or month)
    @date = Date.current if @date.nil?

    @start_date, @end_date =
      case @time_frame
      when 'week' then [@date.beginning_of_week, @date.end_of_week]
      when 'month' then [@date.beginning_of_month, @date.end_of_month]
      end

    work_times =
      WorkTime
      .where(user_id: username)
      .where('DATE(time_in) >= ?', @start_date)
      .where('DATE(time_in) <= ?', @end_date)
      .order(:time_in)


    # How many minutes is left to work
    @left_minutes = total_work_minutes

    @days = get_work_intervals(work_times).map do |intervals|
      work_day_minutes = get_minutes_in_day(intervals.first.time_in)

      left_today =
        if left_minutes >= work_day_minutes
          work_day_minutes
        else
          left_minutes
        end

      # Amount of minutes worked during this day
      total_worked = intervals.sum(&:minutes_worked)

      # Indicates whether user worked more or less (overtime or undertime) in that day,
      # than he should
      # true - overtime, false - undertime
      is_overtime = total_worked > left_today

      # Difference between minutes user worked and minutes he has to work
      # Basically shows how many minutes he has over or underworked
      overtime_minutes = (left_today - total_worked).abs

      is_finished = intervals.all?(&:finished?)

      {
        intervals: intervals,
        total_worked: total_worked,
        is_overtime: is_overtime,
        overtime_minutes: overtime_minutes,
        is_finished: is_finished,
      }
    end

    @left_minutes -= @days.sum { |day| day[:total_worked] }
    @total_overtime = @days.sum { |day| day[:is_overtime] ? day[:overtime_minutes] : -day[:overtime_minutes] }

    # TODO: when to finish work (distributed overtime between rest of days)
    # TODO: when to finish work (start of work + daily hours)
  end

  # Get how many minutes should be worked in a particular date
  #
  # @param date selected date
  #
  # @return number of minutes in selected date
  #
  def get_minutes_in_day(date)
    hours = self.class.special_days[:days][date.to_s] || daily_hours
    hours * 60
  end

  # Days that differ from common
  # E.g. special holidays or short days, etc.
  #
  def self.special_days
    {
      weeks: {
      },
      days: {
      },
    }
  end

  # Get total amount of minutes user have to work during selected date interval
  #
  # @param start_date interval starting point
  # @param end_date interval ending point
  #
  # @return number of work minutes in this interval
  #
  def total_work_minutes
    (@start_date..@end_date).inject(0) do |minutes, date|
      if days_off.exclude?(date.wday)
        minutes += get_minutes_in_day(date)
      end
      minutes
    end
  end

  private

  # Group raw work_times models by date
  # @param work_times raw WorkTime models
  #
  # @return array of arrays of WorkTimes
  #
  def get_work_intervals(work_times)
    work_times
      .group_by do |work_time|
        work_time.time_in.to_date
      end
      .values
  end

  #
  def with_missing_days
    
  end
end
