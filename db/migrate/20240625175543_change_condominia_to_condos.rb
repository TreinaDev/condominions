class ChangeCondominiaToCondos < ActiveRecord::Migration[7.1]
  def change
    rename_table :condominia, :condos
  end
end
