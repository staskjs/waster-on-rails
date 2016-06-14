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
      # TODO: check if work_time actually belongs to current user
      work_time = WorkTime.find(params[:work_time][:id])

      attributes = params.require(:work_time).permit(:time_in, :time_out)
      begin
        time_in = Time.zone.parse(attributes[:time_in])
      rescue
        render json: { error: 'errors.time_in.wrong' }, status: 406
        return
      end
      time_in = work_time.time_in.change(hour: time_in.hour, min: time_in.min)
      attributes[:time_in] = time_in

      begin
        time_out = Time.zone.parse(attributes[:time_out])
      rescue
        render json: { error: 'errors.time_out.wrong' }, status: 406
        return
      end
      time_out = work_time.time_out.change(hour: time_out.hour, min: time_out.min)
      attributes[:time_out] = time_out

      work_time.update_attributes(attributes)

      render json: work_time
    end

  end
end
