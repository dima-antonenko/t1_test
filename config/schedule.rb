# frozen_string_literal: true

require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

scheduler.every "30m" do
  FetchWeatherJob.perform_later
end
