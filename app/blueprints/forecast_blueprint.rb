# frozen_string_literal: true

# Базовый сериалайзер погоды для теста
class ForecastBlueprint < Blueprinter::Base
  # identifier :id

  fields :temperature, :epoch_time
end
