module Forecasts
  # Максимальная за сутки
  class HistoricalMax < BaseService
    include ForecastsValidation

    LIMIT = 24.freeze

    def call
      validate!
      get_res('historical_max_temperature', run_query, CACHE_EXPIRES_MINUTES)
    end

    private

    def validate!
      forecasts_exist?
    end

    def run_query
      Forecast.find_by_sql("SELECT MAX(temperature) as max_temperature FROM (SELECT * FROM forecasts ORDER BY epoch_time DESC LIMIT 24) as recent_forecasts").first.max_temperature
    end
  end
end
