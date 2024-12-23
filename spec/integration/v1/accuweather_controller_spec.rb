# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Accuweather API", type: :request do
  before do
    create(:forecast, epoch_time: Time.current - 1.hour, temperature: 22.5)
    create(:forecast, epoch_time: Time.current - 2.hours, temperature: 18.0)
    create(:forecast, epoch_time: Time.current - 5.hours, temperature: 20.0)
  end

  def run_current_temperature
    get "/weather/current"
    JSON.parse(response.body)
  end

  def run_historical_temperature
    get "/weather/historical"
    JSON.parse(response.body)
  end

  def run_historical_max
    get "/weather/historical/max"
    JSON.parse(response.body)
  end

  def run_historical_min
    get "/weather/historical/min"
    JSON.parse(response.body)
  end

  def run_historical_avg
    get "/weather/historical/avg"
    JSON.parse(response.body)
  end

  def run_by_time(timestamp)
    get "/weather/by_time?timestamp=#{timestamp}"
    JSON.parse(response.body)
  end

  describe "GET /weather/current" do
    it "returns the current temperature" do
      json_response = run_current_temperature

      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key("temperature")
      expect(json_response["temperature"]).to be_present
    end
  end

  describe "GET /weather/historical" do
    it "returns historical temperatures" do
      json_response = run_historical_temperature

      expect(json_response).to have_key("temperatures")
      expect(json_response["temperatures"]).to be_an(Array)
      expect(json_response["temperatures"].size).to be > 0
    end
  end

  describe "GET /weather/historical_max" do
    it "returns the maximum historical temperature" do
      json_response = run_historical_max
      expect(json_response).to have_key("temperature")
      expect(json_response["temperature"]).to eq("22.5")
    end
  end

  describe "GET /weather/historical_min" do
    it "returns the minimum historical temperature" do
      json_response = run_historical_min
      expect(json_response).to have_key("temperature")
      expect(json_response["temperature"]).to eq("18.0")
    end
  end

  describe "GET /weather/historical_avg" do
    it "returns the average historical temperature" do
      json_response = run_historical_avg
      expect(response).to have_http_status(:ok)

      expect(json_response).to have_key("temperature")
      expect(json_response["temperature"].to_f.round(1)).to eq(20.2)
    end
  end

  describe "GET /weather/by_time" do
    context "when forecast find_by_closest_time is present" do
      it "returns the temperature closest to the given timestamp" do
        run_by_time((Time.current - 1.minute).to_i)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("temperature")
        expect(json_response["temperature"]).to eq("22.5")
      end
    end

    context "when forecast find_by_closest_time is nil" do
      it "returns a 404 status code" do
        json_response = run_by_time((Time.current + 2.hours).to_i)
        expect(response).to have_http_status(:not_found)

        expect(json_response).to have_key("error")
        expect(json_response["error"]).to eq("No forecast found within one hour of the given timestamp")
      end
    end
  end
end
