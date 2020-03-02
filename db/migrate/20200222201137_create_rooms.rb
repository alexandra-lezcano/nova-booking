class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :description
      t.string :capacity
      t.integer :price
      t.integer :status
      t.string :room_type

      t.timestamps
    end
  end
end
