class CreateColumnClientInJob < ActiveRecord::Migration[5.0]
  def up
    change_table :jobs do |t|
      t.references :client, foreign_key: true
    end
  end
  def down
    remove_column :jobs, :client
  end
end
