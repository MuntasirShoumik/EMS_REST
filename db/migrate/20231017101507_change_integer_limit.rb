class ChangeIntegerLimit < ActiveRecord::Migration[7.0]
  def change
    change_column :employees, :phone, :integer, limit: 8
    change_column :managers, :phone, :integer, limit: 8

  end
end
