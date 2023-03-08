class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.string "name"
      t.date "year"
      t.date "month"
      t.date "day"
      t.datetime "time"
      t.string "status"
      t.timestamps
    end
  end
end
