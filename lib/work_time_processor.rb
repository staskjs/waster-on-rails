class WorkTimeProcessor
  attr_reader :user
  attr_reader :days_off
  attr_reader :left_minutes
  attr_reader :total_overtime
  attr_reader :day_ends_at
  attr_reader :date_range
  attr_reader :time_frame

  # Contains array of WorkDay elements which represent
  # each new day use checked in
  #
  # @return array<WorkDay>
  #
  attr_reader :days

  def initialize(user, date = nil, time_frame = 'week', count_last = 1)
    @user = user
    @days_off = [0, 6]

    @date = date
    @time_frame = time_frame

    @date = Date.current if @date.nil?

    @date_range = determine_date_range

    calculate

    if count_last > 1
      prev_date = @date - 7.days
      processor = WorkTimeProcessor.new(user, prev_date, time_frame, count_last - 1)
      @total_overtime += processor.total_overtime
    end

  end

  # Calculate range of dates between which intervals will be shown
  # depending on given time frame
  #
  def determine_date_range
    case @time_frame
    when 'week' then (@date.beginning_of_week..@date.end_of_week)
    when 'month' then (@date.beginning_of_month..@date.end_of_month)
    end
  end

  # Get user intervals that lie in selected date range
  #
  def intervals_in_range
    @user.intervals
    .where('DATE(time_in) BETWEEN ? AND ?', @date_range.begin.to_date, @date_range.end.to_date)
    .order(:time_in)
  end

  # Get statistics for selected user since the beginning of selected date
  # for selected time frame (week or month)
  #
  def calculate
    intervals = intervals_in_range

    # How many minutes is left to work
    @left_minutes = total_work_minutes

    @days = get_work_intervals(intervals).map do |interval_group|
      interval_group.sort! { |a, b| a.id <=> b.id }
      date = interval_group.first.time_in.to_date

      work_day_minutes = get_minutes_in_day(date)

      left_today =
        if @left_minutes >= work_day_minutes
          work_day_minutes
        else
          @left_minutes
        end

      # Amount of minutes worked during this day
      total_worked = interval_group.sum(&:minutes_worked)

      @left_minutes -= total_worked
      # Indicates whether user worked more or less (overtime or undertime) in that day,
      # than he should
      # true - overtime, false - undertime
      is_overtime = total_worked > left_today

      # Difference between minutes user worked and minutes he has to work
      # Basically shows how many minutes he has over or underworked
      overtime_minutes = (left_today - total_worked).abs

      is_finished = interval_group.all?(&:finished?)

      WorkDay.new(intervals: interval_group,
                  date: date,
                  total_worked: total_worked,
                  is_overtime: is_overtime,
                  overtime_minutes: overtime_minutes,
                  is_finished: is_finished,
                  is_missing: false,
                  is_day_off: day_off?(date))

    end

    @total_overtime = days.sum(&:overtime)

    # Ideal time when day should be finished
    # Calculated depending on how many hours should be worked at this day
    @day_ends_at = nil
    if unfinished_day
      left_today = get_minutes_in_day(Date.current) - unfinished_day.total_worked
      left_today = @left_minutes if @left_minutes < left_today
      @day_ends_at = Time.zone.now + left_today * 60
    end

    # TODO: when to finish work (distributed overtime between rest of days)
  end

  # Get how many minutes should be worked in a particular date
  #
  # @param date selected date
  #
  # @return number of minutes in selected date
  #
  def get_minutes_in_day(date)
    hours = self.class.special_days[:days][date.to_s] || user.daily_hours
    hours * 60
  end

  # Days that differ from common
  # E.g. special holidays or short days, etc.
  # TODO: move to separate model
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
    @date_range.inject(0) do |minutes, date|
      # Do not count days off
      minutes += get_minutes_in_day(date) unless day_off?(date)
      minutes
    end
  end

  # Get @days with included missing days
  # Missed day is a day when user should have checked in, but didn't
  # By default they are counted as checked in
  #
  def with_missing_days
    @dates = days.map(&:date)
    @date_range.map do |date|

      next days.find { |day| day.date == date } if @dates.include?(date)

      # Subtract missed days from left minutes too
      if !day_off?(date) && date < Date.current
        work_day_minutes = get_minutes_in_day(date)
        @left_minutes -= work_day_minutes

        @left_minutes = 0 if @left_minutes < 0
      end

      WorkDay.new(intervals: [],
                  date: date,
                  total_worked: user.daily_hours,
                  is_overtime: false,
                  overtime_minutes: 0,
                  is_finished: true,
                  is_missing: true,
                  is_day_off: day_off?(date))

    end
  end

  # Check whether date range (week or month) is finished,
  # meaning all days except days off are checked out
  def range_finished?
    with_missing_days
      .select { |day| !day.is_day_off }
      .all? do |day|
        return false if day.is_missing
        day.is_finished
      end
  end

  # Whether user does not have unfinished day
  #
  def checked_out?
    unfinished_day.nil?
  end

  # Get day when user has not checked out
  #
  def unfinished_day
    days.find { |day| !day.is_finished }
  end

  def check
    self.class.check(@user)
  end

  # If user has unfinished day then check out
  # Else check in
  #
  def self.check(user, time_in = nil, time_out = nil)
    time_in = DateTime.current if time_in.nil?
    processor = WorkTimeProcessor.new(user, time_in)
    day = processor.with_missing_days.find do |d|
      d.date.to_date == time_in.to_date
    end

    if day.is_finished
      Interval.create(user_id: user.id, time_in: time_in, time_out: time_out)
    else
      day.check_out
    end
  end

  private

  # Group raw intervals models by date
  #
  # @param intervals raw Interval models
  #
  # @return array of arrays of Intervals
  #
  def get_work_intervals(intervals)
    intervals
      .group_by do |interval|
        interval.time_in.to_date
      end
      .values
  end

  def day_off?(date)
    days_off.include?(date.wday)
  end

end
