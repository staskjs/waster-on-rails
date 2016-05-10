require 'rails_helper'

describe 'WorkTimeProcessor' do
  before :each do
    create(:work_time, date: '2016-05-03 11:00', direction: 'in')
    create(:work_time, date: '2016-05-03 20:00', direction: 'out')
    create(:work_time, date: '2016-05-04 12:00', direction: 'in')
    create(:work_time, date: '2016-05-04 20:00', direction: 'out')
    create(:work_time, date: '2016-05-05 09:00', direction: 'in')
    create(:work_time, date: '2016-05-05 11:00', direction: 'out')
    create(:work_time, date: '2016-05-05 14:00', direction: 'in')
  end
  it 'test' do
    ap WorkTimeProcessor.get('stub')
  end
end
