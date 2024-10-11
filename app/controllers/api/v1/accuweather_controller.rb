module Api
  module V1
    class AccuweatherController < ApplicationController
      def current
        res = Forecasts::CurrentTemperature.new.call
        render json: { temperature: res }
      end

      def historical
        temperatures = Rails.cache.fetch('historical_temperatures', expires_in: 30.minutes) do
          Forecast.historical.pluck(:temperature)
        end
        render json: { temperatures: temperatures }
      end

      def historical_max
        temperature = Rails.cache.fetch('historical_max_temperature', expires_in: 30.minutes) do
          Forecast.historical_max
        end
        render json: { temperature: temperature }
      end

      def historical_min
        temperature = Rails.cache.fetch('historical_min_temperature', expires_in: 30.minutes) do
          Forecast.historical_min
        end
        render json: { temperature: temperature }
      end

      def historical_avg
        temperature = Rails.cache.fetch('historical_avg_temperature', expires_in: 30.minutes) do
          Forecast.historical_avg
        end
        render json: { temperature: temperature }
      end

      def health
        render json: { status: 'OK' }, status: :ok
      end

      def by_time
        timestamp = params[:timestamp].to_i
        forecast = Rails.cache.fetch("forecast_#{timestamp}", expires_in: 30.minutes) do
          Forecast.find_by_closest_time(timestamp)
        end

        if forecast.present?
          render json: { temperature: forecast.temperature }
        else
          render json: { error: 'No forecast found within one hour of the given timestamp' }, status: :not_found
        end
      end
    end
  end
end
