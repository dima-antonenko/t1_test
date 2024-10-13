Rails.application.config.after_initialize do
  if Rails.env.development?
    Rails.cache.delete("accuweather_response")
    # FetchWeatherJob.perform_now
  end
end
