class AddFieldMainInEmailHr < ActiveRecord::Migration[5.2]
  def up
    change_table :email_hrs do |t|
      t.boolean :main
    end
  end
  def down
    remove_column :email_hrs , :main
  end
end
