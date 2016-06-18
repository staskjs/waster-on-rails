module Api
  class WorkTimeController < ApplicationController

    def index
      @processor = WorkTimeProcessor.new('karpov')
    end

    def check
      @processor = WorkTimeProcessor.new('karpov')
      @processor.check
      render nothing: true
    end

    def update
      # TODO: check if interval actually belongs to current user
      interval = Interval.find(params[:interval][:id])

      if interval.user_id != current_user.id
        render json: { error: 'errors.interval.id.invalid' }
        return
      end

      attributes = params.require(:interval).permit(:time_in, :time_out)
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
          attributes[:time_out] = update_time(interval.time_out, attributes[:time_out])
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
    # @params time DateTime object
    # @param value string, representing time on HH:mm format (or any that Time.parse understands)
    #
    # @return new updated Time object
    #
    def update_time(time, value)
      value = Time.zone.parse(value)
      time.change(hour: value.hour, min: value.min)
    end

  end
end
