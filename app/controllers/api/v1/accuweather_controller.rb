# frozen_string_literal: true

module Api
  module V1
    # класс доступа к апи погоды
    class AccuweatherController < ApplicationController
      def current
        res = Forecasts::CurrentTemperature.new.call
        render_json_item(:temperature, res)
      end

      def historical
        res = Forecasts::Historical.new.call
        render json: { temperatures: res }
      end

      def historical_max
        res = Forecasts::HistoricalMax.new.call
        render_json_item(:temperature, res)
      end

      def historical_min
        res = Forecasts::HistoricalMin.new.call
        render_json_item(:temperature, res)
      end

      def historical_avg
        res = Forecasts::HistoricalAvg.new.call
        render_json_item(:temperature, res)
      end

      def health
        render json: { status: "OK" }, status: :ok
      end

      def by_time
        res = Forecasts::ByTime.new(params[:timestamp]).call

        if res.present?
          render_json_item(:temperature, res.temperature)
        else
          render json: { error: "No forecast found within one hour of the given timestamp" }, status: :not_found
        end
      end
    end
  end
end
