require 'net/http'
namespace :legacy do

  desc 'Copy wll intervals from another database'
  task copy: :environment do

    username = 'karpov_s'
    user = User.find(1)

    user_dates = user.intervals.pluck(:time_in).map(&:to_date)

    intervals = []

    end_date = DateTime.current - 1.year - 6.months

    date = DateTime.current.beginning_of_week

    while date >= end_date
      uri = URI("#{Figaro.env.old_waster_url}?username=#{username}&api=true&date=#{date.to_date}")
      data = Net::HTTP.get(uri)
      data = JSON.parse(data)

      data['daysObjectsArray'].each do |day|
        day_date = date + (day['day'] - 1).days
        next if day['fake']
        times = day['times'].map do |work_time|
          begin
            from = Time.zone.parse(work_time['from'])
            time_in = day_date.change(hour: from.hour, min: from.min, offset: '+0300')

            if work_time['to'] == 'сейчас'
              work_time['to'] = '23:59'
            end
            to = Time.zone.parse(work_time['to'])
            time_out = day_date.change(hour: to.hour, min: to.min, offset: '+0300')
          rescue
            ap work_time
          end

          if user_dates.exclude?(time_in.to_date)
            { time_in: time_in, time_out: time_out, user_id: user.id }
          end
        end.compact

        intervals.concat(times)
      end

      date -= 7.days
    end

    ap intervals

    Interval.create(intervals)

  end

end
