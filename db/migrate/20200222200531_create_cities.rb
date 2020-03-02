class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.references :departament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
