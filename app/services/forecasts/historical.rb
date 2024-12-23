# frozen_string_literal: true

module Forecasts
  # Получение температуры за сутки
  class Historical < BaseService
    include ForecastsValidation

    LIMIT = 24

    def call
      validate!
      get_res("historical_temperatures", run_query, CACHE_EXPIRES_MINUTES)
    end

    private

    def validate!
      forecasts_exist?
    end

    def run_query
      Forecast.find_by_sql("SELECT * FROM forecasts ORDER BY epoch_time DESC LIMIT 24")
    end
  end
end
