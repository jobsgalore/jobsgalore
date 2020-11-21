class AddIndexesToJob < ActiveRecord::Migration[5.2]
  def change
    add_index :jobs, :sources
  end
end
