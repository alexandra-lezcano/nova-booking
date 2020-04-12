class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :description
      t.integer :rating
      t.string :client_name
      t.string :client_email
      t.references :estate, foreign_key: true

      t.timestamps
    end
  end
end
