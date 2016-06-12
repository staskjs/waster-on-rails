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

    # 22 hours worked + 3.5 hours until now
    # overtimes: -1.5, 0.5, -4.5

    @time_now = Time.new(2016, 5, 5, 17, 30, 0, 0)
    allow(Time).to receive(:now).and_return(@time_now)

    @processor = WorkTimeProcessor.new('stub')
  end
  it 'default days (current date, for week)' do
    # ap WorkTimeProcessor.get('stub', Date.new(2016, 04, 30), 'week')
    # ap @processor.days

    expect(@processor.days.length).to eq 4
  end

  it 'missing days' do
    days = @processor.with_missing_days
    expect(days.length).to eq 7
    expect(days.last[:date]).to eq Date.new(2016, 5, 8)
  end

  it 'left_minutes' do
    left_minutes = (42.5 - 22 - 3.5) * 60
    expect(@processor.left_minutes).to eq left_minutes
  end

  it 'total_overtime' do
    total_overtime = (-1.5 + 0.5 - 4.5) * 60
    expect(@processor.total_overtime).to eq total_overtime
  end

  # Empty week has 0 overtime, because all days are not finished
  it 'total_overtime in empty week' do
    @processor = WorkTimeProcessor.new('stub2')
    expect(@processor.total_overtime).to eq 0
  end

  it 'checked out?' do
    expect(@processor.checked_out?).to eq false
    # @processor.check_out
    # expect(@processor.checked_out?).to eq true
  end

  it 'unfinished day' do
    expect(@processor.unfinished_day).to eq @processor.days[3]
  end

  # TODO: test when checked out next day

  it 'check' do
    @processor.check
    @processor = WorkTimeProcessor.new('stub')
    expect(@processor.checked_out?).to eq true
    # expect(@processor.days[3])
  end

  describe 'overtimes' do
    it '1' do
      expect(@processor.days[0].overtime_minutes).to eq 90
      expect(@processor.days[1].overtime_minutes).to eq 30
      expect(@processor.days[2].overtime_minutes).to eq 270
      expect(@processor.days[3].overtime_minutes).to eq 180
    end

    it '2' do
      WorkTime.delete_all
      create(:work_time, time_in: '2016-05-02 07:41', time_out: '2016-05-02 16:25')
      create(:work_time, time_in: '2016-05-03 12:13', time_out: '2016-05-03 18:38')
      create(:work_time, time_in: '2016-05-07 07:35', time_out: '2016-05-07 17:37')
      @processor = WorkTimeProcessor.new('stub')
      days = @processor.with_missing_days
      expect(days[0].overtime_minutes).to eq 14
      expect(days[1].overtime_minutes).to eq 125
      expect(days[2].overtime_minutes).to eq 0
      expect(days[3].overtime_minutes).to eq 0
      expect(days[4].overtime_minutes).to eq 0
      expect(days[5].overtime_minutes).to eq 92

    end
  end

  describe 'work minutes' do
    it 'week' do
      minutes = @processor.total_work_minutes
      expect(minutes).to eq 5 * 8.5 * 60
    end

    it 'month' do
      @processor = WorkTimeProcessor.new('stub', nil, 'month')
      minutes = @processor.total_work_minutes
      expect(minutes).to eq 22 * 8.5 * 60
    end

    it 'friday as holiday' do
      allow(@processor).to receive(:days_off).and_return([0, 5, 6])
      minutes = @processor.total_work_minutes
      expect(minutes).to eq 4 * 8.5 * 60

      @processor = WorkTimeProcessor.new('stub', nil, 'month')
      allow(@processor).to receive(:days_off).and_return([0, 5, 6])
      minutes = @processor.total_work_minutes
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
