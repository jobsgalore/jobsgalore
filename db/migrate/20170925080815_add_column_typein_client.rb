class AddColumnTypeinClient < ActiveRecord::Migration[5.0]
  def up
    change_table :clients do |t|
      t.string :type
    end
  end
  def down
    remove_column :clients, :type
  end
end
