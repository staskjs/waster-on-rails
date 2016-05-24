require 'rails_helper'

describe 'WorkTimeProcessor' do
  before :each do
    create(:work_time, time_in: '2016-04-30 11:00', time_out: '2016-04-30 17:00')
    create(:work_time, time_in: '2016-05-01 08:00', time_out: '2016-05-01 21:00')
    create(:work_time, time_in: '2016-05-02 10:00', time_out: '2016-05-02 17:00')
    create(:work_time, time_in: '2016-05-03 11:00', time_out: '2016-05-03 20:00')
    create(:work_time, time_in: '2016-05-04 12:00', time_out: '2016-05-04 16:00')
    create(:work_time, time_in: '2016-05-05 09:00', time_out: '2016-05-05 11:00')
    create(:work_time, time_in: '2016-05-05 14:00')

    @time_now = Time.new(2016, 5, 5, 17, 30, 0, 0)
    allow(Time).to receive(:now).and_return(@time_now)

    @processor = WorkTimeProcessor.new('stub')
  end
  it 'test' do
    # ap WorkTimeProcessor.get('stub', Date.new(2016, 04, 30), 'week')
    ap @processor.get
  end

  describe 'work minutes' do
    it 'week' do
      minutes = @processor.total_work_minutes(Date.current.beginning_of_week, Date.current.end_of_week)
      expect(minutes).to eq 5 * 8.5 * 60
    end

    it 'month' do
      minutes = @processor.total_work_minutes(Date.current.beginning_of_month, Date.current.end_of_month)
      expect(minutes).to eq 22 * 8.5 * 60
    end

    it 'friday as holiday' do
      allow(@processor).to receive(:days_off).and_return([0, 5, 6])
      minutes = @processor.total_work_minutes(Date.current.beginning_of_week, Date.current.end_of_week)
      expect(minutes).to eq 4 * 8.5 * 60

      minutes = @processor.total_work_minutes(Date.current.beginning_of_month, Date.current.end_of_month)
      expect(minutes).to eq 18 * 8.5 * 60
    end

    describe 'special days' do
      it 'holidays' do

      end

      it 'short day' do

      end
    end
  end
end
