# frozen_string_literal: true

module Forecasts
  # Получение минимальной температуры за сутки
  class HistoricalMin < BaseService
    include ForecastsValidation

    LIMIT = 24

    def call
      validate
      get_res("historical_min_temperature", run_query, CACHE_EXPIRES_MINUTES)
    end

    private

    def validate
      forecasts_exist?
    end

    def run_query
      Forecast.find_by_sql("SELECT MIN(temperature) as min_temperature FROM (SELECT * FROM forecasts \
                                                          ORDER BY epoch_time DESC LIMIT 24) \
                                                          as recent_forecasts").first.min_temperature
    end
  end
end
