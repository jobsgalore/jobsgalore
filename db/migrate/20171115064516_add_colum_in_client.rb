class AddColumInClient < ActiveRecord::Migration[5.0]
  def up
    change_table :clients do |t|
      t.boolean :send_email, null: false, default: true
    end
  end
  def down
    remove_column :clients, :send_email
  end
end
