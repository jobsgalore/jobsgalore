class DeleteRespFromClients < ActiveRecord::Migration[5.0]
  def up
    remove_column :clients, :resp

  end
  def down
    change_table :clients do |t|
      t.boolean :resp
    end
  end
end
