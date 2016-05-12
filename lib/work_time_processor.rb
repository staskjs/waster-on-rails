module WorkTimeProcessor
  extend self

  # Get statistics for selected user since the beginning of selected date
  # for selected time frame (week or month)
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
      .where('DATE(date) >= ?', start_date)
      .where('DATE(date) <= ?', end_date)

    intervals = get_work_intervals(work_times)
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
        work_time.date.to_date
      end
      .values
      .flat_map do |group|
        group.in_groups_of(2, nil)
      end
      .map do |entry|
        in_item = entry.find(&:in?)
        out_item = entry.find { |work_time| work_time.try(:out?) }

        minutes =
          if out_item.nil?
            TimeDifference.between(in_item.date, Time.current).in_minutes
          else
            TimeDifference.between(in_item.date, out_item.date).in_minutes
          end
        {
          day: in_item.date.wday,
          minutes: minutes,
          in_item: in_item,
          out_item: out_item,
          finished: out_item.present?,
        }
      end
  end

  #
  def fill_missing_days(intervals)
  end

  # Get how many minutes should be worked in a particular date
  def get_minutes_in_day(date)
    hours = special_days.days[date] || 8.5
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
end
