require 'rails_helper'

describe 'WorkTimeProcessor' do
  before :each do
    create(:work_time, date: '2016-04-30 11:00', direction: 'in')
    create(:work_time, date: '2016-04-30 17:00', direction: 'out')
    create(:work_time, date: '2016-05-01 08:00', direction: 'in')
    create(:work_time, date: '2016-05-01 21:00', direction: 'out')
    create(:work_time, date: '2016-05-02 10:00', direction: 'in')
    create(:work_time, date: '2016-05-02 14:00', direction: 'out')
    create(:work_time, date: '2016-05-03 11:00', direction: 'in')
    create(:work_time, date: '2016-05-03 20:00', direction: 'out')
    create(:work_time, date: '2016-05-04 12:00', direction: 'in')
    create(:work_time, date: '2016-05-04 20:00', direction: 'out')
    create(:work_time, date: '2016-05-05 09:00', direction: 'in')
    create(:work_time, date: '2016-05-05 11:00', direction: 'out')
    create(:work_time, date: '2016-05-05 14:00', direction: 'in')

    @time_now = Time.new(2016, 5, 5, 17, 30, 0, 0)
    allow(Time).to receive(:now).and_return(@time_now)
  end
  it 'test' do
    # ap WorkTimeProcessor.get('stub', Date.new(2016, 04, 30), 'week')
    ap WorkTimeProcessor.get('stub')
  end
end
