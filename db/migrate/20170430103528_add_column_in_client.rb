class AddColumnInClient < ActiveRecord::Migration[5.0]
  def change
    change_table :clients do |t|
      t.date :birth
    end
  end

  def down
    remove_column :clients, :birth
  end
end
