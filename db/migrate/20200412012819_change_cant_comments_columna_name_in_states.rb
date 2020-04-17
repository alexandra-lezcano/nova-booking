class ChangeCantCommentsColumnaNameInStates < ActiveRecord::Migration[5.2]
  def change
    rename_column :estates, :cant_comments, :comments_quant
  end
end
