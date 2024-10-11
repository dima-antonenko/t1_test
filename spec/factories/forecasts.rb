FactoryBot.define do
  factory :forecast do
    epoch_time { Time.current - 1.hour }
    temperature { 20 }
  end
end
