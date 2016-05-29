module Api
  class WorkTimeController < ApplicationController
    def index
      @processor = WorkTimeProcessor.new('karpov_s')
    end
  end
end
