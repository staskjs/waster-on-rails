module Api
  class WorkTimeController < ApplicationController
    def index
      @processor = WorkTimeProcessor.new('karpov')
    end
  end
end
