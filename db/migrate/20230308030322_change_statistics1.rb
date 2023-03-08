class ChangeStatistics1 < ActiveRecord::Migration[7.0]
  def change
    change_column :statistics, :year, :string 
    change_column :statistics, :month, :string 
    change_column :statistics, :day, :string 
  end
end
