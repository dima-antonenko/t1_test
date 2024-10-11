require 'rails_helper'

RSpec.describe 'Accuweather API', type: :request do
  before do
    create(:forecast, epoch_time: Time.current - 1.hour, temperature: 22.5)
    create(:forecast, epoch_time: Time.current - 2.hours, temperature: 18.0)
    create(:forecast, epoch_time: Time.current - 5.hours, temperature: 20.0)
  end

  def get_current_temperature
    get '/weather/current'
    JSON.parse(response.body)
  end

  def get_historical_temperature
    get '/weather/historical'
    JSON.parse(response.body)
  end


  describe 'GET /weather/current' do
    it 'returns the current temperature' do
      json_response = get_current_temperature

      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key('temperature')
      expect(json_response['temperature']).to be_present
    end
  end

  describe 'GET /weather/historical' do
    it 'returns historical temperatures' do
      json_response = get_historical_temperature

      expect(json_response).to have_key('temperatures')
      expect(json_response['temperatures']).to be_an(Array)
      expect(json_response['temperatures'].size).to be > 0
    end
  end

  describe 'GET /weather/historical_max' do
    it 'returns the maximum historical temperature' do
      get '/weather/historical/max'
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('temperature')
      expect(json_response['temperature']).to eq('22.5')
    end
  end

  describe 'GET /weather/historical_min' do
    it 'returns the minimum historical temperature' do
      get '/weather/historical/min'
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('temperature')
      expect(json_response['temperature']).to eq('18.0')
    end
  end

  describe 'GET /weather/historical_avg' do
    it 'returns the average historical temperature' do
      get '/weather/historical/avg'
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('temperature')
      expect(json_response['temperature'].to_f.round(1)).to eq(20.2)
    end
  end

  describe 'GET /weather/by_time' do
    context 'when forecast find_by_closest_time is present' do
      it 'returns the temperature closest to the given timestamp' do
        timestamp = (Time.current - 1.minute).to_i
        get "/weather/by_time?timestamp=#{timestamp}"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('temperature')
        expect(json_response['temperature']).to eq('22.5')
      end
    end

    context 'when forecast find_by_closest_time is nil' do
      it 'returns a 404 status code' do
        timestamp = (Time.current + 2.hours).to_i
        get "/weather/by_time?timestamp=#{timestamp}"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('error')
        expect(json_response['error']).to eq('No forecast found within one hour of the given timestamp')
      end
    end
  end
end
