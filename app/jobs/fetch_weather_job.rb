# frozen_string_literal: true

# джоба для синхронизации погоды
class FetchWeatherJob < ApplicationJob
  queue_as :default

  def perform
    AccuweatherService.new.call
  end
end
