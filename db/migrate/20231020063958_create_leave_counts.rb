class CreateLeaveCounts < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_counts do |t|
      t.integer :count
      t.references :employee, foreign_key: { to_table: :employees, on_delete: :cascade }

      t.timestamps
    end
  end
end
