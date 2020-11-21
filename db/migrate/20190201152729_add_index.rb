class AddIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :jobs, :urgent
  end
end
