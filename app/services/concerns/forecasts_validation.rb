module ForecastsValidation
  def forecasts_exist?
    raise PermissionError.new(:forecast_id, "Таблица пуста") if Forecast.all.size.zero?
  end
end
