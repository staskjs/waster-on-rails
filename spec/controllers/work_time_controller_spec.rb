require 'rails_helper'

describe Api::WorkTimeController, type: :controller do

  describe 'edit intervals' do
    before :each do
      @interval1 = create(:interval, time_in: '2016-05-05 09:00', time_out: '2016-05-05 11:00')
      @interval2 = create(:interval, time_in: '2016-05-05 14:00', time_out: '2016-05-05 17:30')

      @time_now = Time.new(2016, 5, 5, 17, 30, 0, 0)
      allow(Time).to receive(:now).and_return(@time_now)
    end

    it 'simple update both' do
      post :update, interval: { id: @interval1.id, time_in: '10:33', time_out: '12:00' }

      @interval1 = @interval1.reload
      expect(@interval1.time_in.hour).to eq 10
      expect(@interval1.time_in.min).to eq 33
    end

    it 'remove time_in' do
      post :update, interval: { id: @interval1.id, time_in: '', time_out: '12:00' }

      expect { @interval1 = @interval1.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'remove time_out from non-latest interval (from first)' do
      post :update, interval: { id: @interval1.id, time_in: '10:00', time_out: '' }

      @interval1 = @interval1.reload
      expect(@interval1.time_in.hour).to eq 10
      expect(@interval1.time_out).not_to be nil
      expect(@interval1.time_out.hour).to eq 11
      expect(@interval1.finished?).to be true
    end

    it 'remove time_out from latest interval' do
      post :update, interval: { id: @interval2.id, time_in: '10:00', time_out: '' }

      @interval2 = @interval2.reload
      expect(@interval2.time_in.hour).to be 10
      expect(@interval2.time_out).to be nil
      expect(@interval2.finished?).to be false
    end

  end

end
