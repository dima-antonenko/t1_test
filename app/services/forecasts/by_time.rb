module Forecasts
  # Получение температуры по времени
  class ByTime < BaseService
    include ForecastsValidation
    attr_reader :timestamp

    def initialize(timestamp)
      @timestamp = timestamp
    end

    def call
      validate!
      get_res("forecast_#{timestamp}", run_query, CACHE_EXPIRES_MINUTES)
    end

    private

    def validate!
      forecasts_exist?
    end

    def run_query
      time = Time.at(timestamp.to_i)

      Forecast.where('epoch_time BETWEEN ? AND ?', time - 1.hour, time + 1.hour)
              .order(Arel.sql("ABS(extract(epoch from epoch_time) - #{timestamp})"))
              .first
    end
  end
end
