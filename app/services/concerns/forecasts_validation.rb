# frozen_string_literal: true

# Модуль с валидациями погодных данных
module ForecastsValidation
  def forecasts_exist?
    raise PermissionError.new(:forecast_id, "Таблица пуста") if Forecast.all.empty?
  end
end
