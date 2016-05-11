module WorkTimeProcessor
  extend self

  def get(username = 'karpov_s', date = nil, count_last_week = 1)
    work_times = WorkTime.where(user_id: username)
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
  def get_work_intervals(work_times)
    work_times.group_by do |work_time|
      work_time.date.to_date
    end
    .values
    .map do |group|
      group.in_groups_of(2, nil)
    end
    .flatten(1)
    .map do |entry|
      in_item = entry.find { |work_time| work_time.in? }
      out_item = entry.find { |work_time| work_time.try(:out?) }

      minutes =
        if out_item.nil?
          TimeDifference.between(in_item.date, Time.now).in_minutes
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

  def fill_missing_days
    
  end

  # Get how many minutes should be worked in a particular date
  def get_minutes_in_day(date)
    hours = special_days.days[date]
    if hours.empty?
      hours = 8.5
    end
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
