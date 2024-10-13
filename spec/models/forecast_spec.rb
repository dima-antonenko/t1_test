# == Schema Information
#
# Table name: forecasts
#
#  id          :bigint           not null, primary key
#  temperature :decimal(, )      not null
#  epoch_time  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe 'Scopes' do
    let!(:forecast1) { create(:forecast, epoch_time: 1.hour.ago, temperature: 20) }
    let!(:forecast2) { create(:forecast, epoch_time: 2.hours.ago, temperature: 15) }
    let!(:forecast3) { create(:forecast, epoch_time: 3.hours.ago, temperature: 25) }

    describe '.historical' do
      it 'returns the most recent 24 records' do
        expect(Forecast.historical).to include(forecast1, forecast2, forecast3)
        expect(Forecast.historical.count).to be <= 24
      end
    end

    describe '.current_temperature' do
      it 'returns the most recent temperature record' do
        expect(Forecast.current_temperature).to eq(forecast1.temperature)
      end
    end

    describe '.historical_max' do
      it 'returns the maximum temperature from historical data' do
        expect(Forecast.historical_max).to eq(25)
      end
    end

    describe '.historical_min' do
      it 'returns the minimum temperature from historical data' do
        expect(Forecast.historical_min).to eq(15)
      end
    end

    describe '.historical_avg' do
      it 'returns the average temperature from historical data' do
        expected_avg = (20 + 15 + 25) / 3.0
        expect(Forecast.historical_avg).to eq(expected_avg)
      end
    end
  end

  describe '.find_by_closest_time' do
    let!(:forecast1) { create(:forecast, epoch_time: Time.current - 2.hours, temperature: 20) }
    let!(:forecast2) { create(:forecast, epoch_time: Time.current - 1.hour, temperature: 25) }
    let!(:forecast3) { create(:forecast, epoch_time: Time.current - 30.minutes, temperature: 22) }

    it 'returns the forecast closest to the given timestamp' do
      timestamp = Time.current.to_i
      closest_forecast = Forecast.find_by_closest_time(timestamp)

      expect(closest_forecast).to eq(forecast3)
    end

    it 'returns nil if no forecast is found within one hour of the given timestamp' do
      timestamp = (Time.current + 40.minutes).to_i
      closest_forecast = Forecast.find_by_closest_time(timestamp)

      expect(closest_forecast).to be_nil
    end
  end
end
