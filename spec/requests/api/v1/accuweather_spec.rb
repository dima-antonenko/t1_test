require 'swagger_helper'

RSpec.describe 'api/v1/accuweather', type: :request do

  before do
    create(:forecast, epoch_time: Time.now, temperature: 19)
    create(:forecast, epoch_time: 1.day.ago, temperature: 15)
    create(:forecast, epoch_time: 2.days.ago, temperature: 11)
  end

  path '/weather/historical/min' do
    get('historical_min accuweather') do
      response(200, 'successful') do
        let(:expected_response) { { temperature: '11.0' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  path '/weather/historical/max' do
    get('historical_max accuweather') do
      response(200, 'successful') do
        let(:expected_response) { { temperature: '19.0' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  path '/weather/historical/avg' do
    get('historical_avg accuweather') do
      response(200, 'successful') do
        let(:expected_response) { { temperature: '15.0' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  path '/weather/current' do
    get('current accuweather') do
      response(200, 'successful') do
        let(:expected_response) { { temperature: '19.0' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  path '/weather/historical' do
    get('historical accuweather') do
      response(200, 'successful') do
        let(:expected_response) { { temperatures: ['19.0', '15.0', '11.0'] }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  path '/weather/by_time' do
    get('by_time accuweather') do
      parameter name: :timestamp, in: :query, type: :integer, description: 'Timestamp for the forecast'

      response(200, 'successful') do
        let(:timestamp) { Time.now.to_i }
        let(:expected_response) { { temperature: '19.0' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end

      response(404, 'not found') do
        let(:timestamp) { (Time.now - 2.hours).to_i }
        let(:expected_response) { { error: 'No forecast found within one hour of the given timestamp' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  path '/health' do
    get('health accuweather') do
      response(200, 'successful') do
        let(:expected_response) { { status: 'OK' }.to_json }

        run_test! do |response|
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end
end
