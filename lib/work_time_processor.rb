module WorkTimeProcessor
  extend self

  # Get statistics for selected user since the beginning of selected date
  # for selected time frame (week or month)
  #
  def get(username = 'karpov_s', date = nil, time_frame = 'week', count_last = 1)
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

    intervals = get_work_intervals(work_times)
    return intervals

    # Total number of minutes to work
    total_minutes = total_work_minutes(start_date, end_date)

    # How many minutes is left to work
    left_minutes = total_minutes
  end

  private

  # Get information about worked intervals for given raw data
  # @param work_times raw WorkTime models
  #
  # @return array of objects with structure:
  #     day: weekday (ordinal weekday number)
  #     minutes: total minutes worked during this interval
  #     in_time: time checked in
  #     out_time: time checked out
  #     finished: is interval finished
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

  # Get how many minutes should be worked in a particular date
  #
  # @param date selected date
  #
  # @return number of minutes in selected date
  #
  def get_minutes_in_day(date)
    hours = special_days[:days][date.to_s] || 8.5
    hours * 60
  end

  def special_days
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
  def total_work_minutes(start_date, end_date)
     (start_date..end_date).inject(0) do |minutes, date|
       minutes += get_minutes_in_day(date)
       minutes
     end
  end

end
