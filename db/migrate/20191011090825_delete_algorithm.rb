class DeleteAlgorithm < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :algorithm_id
    drop_table :algorithms
  end
end
