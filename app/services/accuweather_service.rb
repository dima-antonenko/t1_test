# frozen_string_literal: true

# Базовый класс получения данных из погодного сервиса
class AccuweatherService
  API_KEY = ENV.fetch("ACCUWEATHER_TOKEN").freeze
  LOCATION = ENV.fetch("LOCATION_KEY").freeze

  def call
    Rails.cache.fetch("accuweather_response", expires_in: 30.minutes) do
      parsed_response.each do |weather|
        res = Forecast
              .find_or_initialize_by(epoch_time: Time.at(weather["EpochTime"]))
              .update(temperature: weather.dig("Temperature", "Metric", "Value"))
        Rails.logger.debug res
      end
    end
  end

  private

  def api_url
    "https://dataservice.accuweather.com/currentconditions/v1/#{LOCATION}/historical/24"
  end

  def parsed_response
    HTTParty.get(api_url, query: { apikey: API_KEY }).parsed_response
  end
end
