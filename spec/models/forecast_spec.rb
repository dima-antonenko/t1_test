# frozen_string_literal: true

# == Schema Information
#
# Table name: forecasts
#
#  id          :bigint           not null, primary key
#  temperature :decimal(, )      not null
#  epoch_time  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe Forecast, type: :model do
  it "is valid with valid attributes" do
    expect(Forecast.new(epoch_time: 12345, temperature: "12")).to be_valid
  end
end
