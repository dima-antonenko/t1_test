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
FactoryBot.define do
  factory :forecast do
    epoch_time { Time.current - 1.hour }
    temperature { 20 }
  end
end
