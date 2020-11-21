class RenameColumnTypeToCharacter < ActiveRecord::Migration[5.0]
  def change
    rename_column :clients, :type, :character
  end
end
