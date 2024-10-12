class CreateForecasts < ActiveRecord::Migration[7.2]
  def change
    create_table :forecasts do |t|
      t.decimal :temperature, index: true, null: false
      t.timestamp :epoch_time, index: true, null: false

      t.timestamps
    end
  end
end
