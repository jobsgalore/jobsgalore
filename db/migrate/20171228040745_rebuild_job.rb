class RebuildJob < ActiveRecord::Migration[5.0]
  def up
    remove_column :jobs, :twitter
    change_table :jobs do |t|
      t.string :twitter
    end
  end

  def down
    remove_column :jobs, :twitter
    change_table :jobs do |t|
      t.boolean :twitter
    end
  end
end
