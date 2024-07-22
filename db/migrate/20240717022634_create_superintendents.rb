class CreateSuperintendents < ActiveRecord::Migration[7.1]
  def change
    create_table :superintendents do |t|
      t.references :resident, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
