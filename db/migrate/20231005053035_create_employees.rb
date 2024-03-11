class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.string :position
      t.string :dept
      t.string :password_digest

      t.timestamps
    end
  end
end
