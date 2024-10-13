class FetchWeatherJob < ApplicationJob
  queue_as :default

  def perform
    AccuweatherService.new.call
  end
end
