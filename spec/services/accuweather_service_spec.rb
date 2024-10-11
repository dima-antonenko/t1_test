require 'rails_helper'

RSpec.describe AccuweatherService, type: :service do
  describe '#call' do
    it 'updates Forecast records with temperatures from Accuweather API', :vcr do
      AccuweatherService.call

      expect(Forecast.count).to be > 0

      forecast = Forecast.first
      expect(forecast).to have_attributes(
        epoch_time: be_present,
        temperature: be_present
      )
    end
  end
end
