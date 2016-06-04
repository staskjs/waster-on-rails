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

  end
end
