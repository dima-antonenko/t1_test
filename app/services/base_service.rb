class BaseService
  CACHE_EXPIRES_MINUTES = 30.freeze
  def get_res(key, value, expires_in_minutes = 30)
    Rails.cache.fetch(key, expires_in: expires_in_minutes.minutes) do
      value
    end
  end
end
