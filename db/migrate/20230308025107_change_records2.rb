class ChangeRecords2 < ActiveRecord::Migration[7.0]
  def change
    change_column :records, :year, :string 
    change_column :records, :month, :string 
    change_column :records, :day, :string 
  end
end
