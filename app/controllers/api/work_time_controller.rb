module Api
  class WorkTimeController < ApplicationController

    before_action :authenticate_user!

    def index
      date = params[:date] ? Date.parse(params[:date]) : nil
      time_frame = params[:time_frame] ? params[:time_frame] : 'week'
      last = params[:last] ? params[:last] : 1
      @processor = WorkTimeProcessor.new(current_user, date, time_frame, last)
    end

    def check
      @processor = WorkTimeProcessor.new(current_user)
      @processor.check
      render nothing: true
    end

    def update
      interval = Interval.find(params[:interval][:id])

      if interval.user_id != current_user.id
        render json: { error: 'errors.interval.id.invalid' }
        return
      end

      attributes = params.require(:interval).permit(:time_in, :time_out, :date_out)
      if attributes[:time_in].present?
        begin
          attributes[:time_in] = update_time(interval.time_in, attributes[:time_in])
        rescue
          render json: { error: 'errors.time_in.wrong' }, status: 406
          return
        end
      end

      if attributes[:time_out].present?
        begin
          attributes[:time_out] = update_time(interval.time_out, attributes[:time_out], attributes[:date_out])
          attributes.except!(:date_out)
        rescue
          render json: { error: 'errors.time_out.wrong' }, status: 406
          return
        end
      end

      @processor = WorkTimeProcessor.new(current_user)

      # Prevent deleting time_out from non-latest interval
      is_interval_latest = @processor.days.any? do |day|
        day.interval_latest?(interval)
      end

      if !is_interval_latest && !attributes[:time_out].present?
        attributes.except!(:time_out)
      end

      if attributes[:time_in].present?
        interval.update_attributes(attributes)
      else
        interval.delete
      end

      render json: interval
    end

    private

    # Update given DateTime object's time by given value
    #
    # @param time DateTime object
    # @param value string, representing time on HH:mm format (or any that Time.parse understands)
    # @param date choose another date for given DateTime object
    #
    # @return new updated Time object
    #
    def update_time(time, value, date = nil)
      value = Time.zone.parse(value)
      time = DateTime.parse(date).utc if date.present?
      time.change(hour: value.hour, min: value.min)
    end

  end
end
