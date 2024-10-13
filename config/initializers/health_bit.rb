# frozen_string_literal: true

HealthBit.configure do |c|
  # DEFAULT SETTINGS ARE SHOWN BELOW
  c.success_text = "%<count>d checks passed 🎉"
  c.headers = {
    "Content-Type" => "text/plain;charset=utf-8",
    "Cache-Control" => "private,max-age=0,must-revalidate,no-store"
  }
  c.success_code = 200
  c.fail_code = 500
  c.show_backtrace = false
  c.formatter = HealthBit::Formatter.new
  # DEFAULT SETTINGS ARE SHOWN ABOVE

  c.add("Check name") do
    true
  end
end

HealthBit.add("PostgreSQL") do |_env|
  ApplicationRecord.connection.select_value("SELECT 1") == 1
end

HealthBit.add("Custom") do |_env|
  true
end

HealthBit.add("Database") do |_env|
  true
end

HealthBit.add("Docker service") do |_env|
  true
end
