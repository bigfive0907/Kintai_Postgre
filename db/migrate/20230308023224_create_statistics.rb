class CreateStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :statistics do |t|
      t.string "name"
      t.date "year"
      t.date "month"
      t.date "day"
      t.float "worktime"
      t.float "idletime"
      t.float "overtime"
      
      t.timestamps
    end
  end
end
