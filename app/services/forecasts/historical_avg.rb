# frozen_string_literal: true

module Forecasts
  # Класс получения среднесуточной температуры
  class HistoricalAvg < BaseService
    include ForecastsValidation

    LIMIT = 24

    def call
      validate!
      get_res("historical_avg_temperature", run_query, CACHE_EXPIRES_MINUTES)
    end

    private

    def validate!
      forecasts_exist?
    end

    def run_query
      Forecast.find_by_sql("SELECT AVG(temperature) as avg_temperature FROM (SELECT * FROM forecasts \
                            ORDER BY epoch_time DESC LIMIT 24) \
                            as recent_forecasts").first.avg_temperature
    end
  end
end
