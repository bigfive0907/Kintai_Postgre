class ChangeRecords < ActiveRecord::Migration[7.0]
  def change
    change_column :records, :year, :timestamp 
    change_column :records, :month, :timestamp 
    change_column :records, :day, :timestamp 
  end
end
