class WorkTimeProcessor
  attr_reader :username
  attr_reader :days_off
  attr_reader :daily_hours

  def initialize(username)
    @username = username
    @days_off = [0, 6]
    @daily_hours = 8.5
  end

  # Get statistics for selected user since the beginning of selected date
  # for selected time frame (week or month)
  #
  def get(date = nil, time_frame = 'week', count_last = 1)
    date = Date.current if date.nil?

    start_date, end_date =
      case time_frame
      when 'week' then [date.beginning_of_week, date.end_of_week]
      when 'month' then [date.beginning_of_month, date.end_of_month]
      end

    work_times =
      WorkTime
      .where(user_id: username)
      .where('DATE(time_in) >= ?', start_date)
      .where('DATE(time_in) <= ?', end_date)
      .order(:time_in)

    # Total number of minutes to work
    # TODO: subtract weekends and holidays
    total_minutes = total_work_minutes(start_date, end_date)

    # How many minutes is left to work
    left_minutes = total_minutes

    get_work_intervals(work_times).map do |intervals|
      work_day_minutes = get_minutes_in_day(intervals.first.time_in)

      left_today =
        if left_minutes >= work_day_minutes
          work_day_minutes
        else
          left_minutes
        end

      # Amount of minutes worked during this day
      total_worked = intervals.sum(&:minutes_worked)

      # Indicates whether user worked more or less in that day, than he should
      # true - more, false - less
      is_total_worked_more = total_worked > left_today

      # Difference between minutes user worked and minutes he has to work
      # Basically shows how many minutes he has over or underworked
      total_minutes_of_diff = (left_today - total_worked).abs

      # TODO: count total diff minutes

      left_minutes -= total_worked

      is_finished = intervals.all?(&:finished?)

      {
        intervals: intervals,
        total_worked: total_worked,
        total_worked_more: is_total_worked_more,
        total_minutes_of_diff: total_minutes_of_diff,
        is_finished: is_finished,
      }
    end

    # TODO: total overtime (or undertime)
    # TODO: how many minutes left to work
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
  def fill_missing_days(intervals)
  end

  # Get total amount of minutes user have to work during selected date interval
  #
  # @param start_date interval starting point
  # @param end_date interval ending point
  #
  # @return number of work minutes in this interval
  #
  def total_work_minutes(start_date, end_date)
    (start_date..end_date).inject(0) do |minutes, date|
      minutes += get_minutes_in_day(date)
      minutes
    end
  end
end
