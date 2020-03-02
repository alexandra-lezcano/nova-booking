# frozen_string_literal: true
class AddTypeToEstates < ActiveRecord::Migration[6.0]
  def change
    add_column :estates, :estate_type, :string
  end
end
