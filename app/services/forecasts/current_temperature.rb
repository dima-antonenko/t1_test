# frozen_string_literal: true

module Forecasts
  # Получение текущей температуры
  class CurrentTemperature < BaseService
    include ForecastsValidation

    LIMIT = 1
    CACHE_EXPIRES_MINUTES = 30
    def call
      validate!
      get_res("current_temp", run_query, CACHE_EXPIRES_MINUTES)
    end

    private

    def validate!
      forecasts_exist?
    end

    def run_query
      Forecast.find_by_sql("SELECT temperature FROM forecasts ORDER BY epoch_time DESC LIMIT 1").first.temperature
    end
  end
end
