class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.date :deadline
      t.string :status

      t.timestamps
    end
  end
end
