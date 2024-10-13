# frozen_string_literal: true

# базовый класс мейлера
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
