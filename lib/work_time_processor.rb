class WorkTimeProcessor
  
  def get(username, date, count_last_week = 1)
    
  end

  private

  # Get information about worked time for given raw data
  # @param work_times raw WorkTime models
  #
  # @return array of objects with structure:
  #     fake: boolean - whether user did not check in this day
  #     day: integer - iso weekday (ordinal weekday number)
  #     times: array of time interval objects with structore:
  #         minutes: total minutes worked during this interval
  #         in_time: time checked in
  #         out_time: time checked out
  def get_week_day_minutes
    
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
