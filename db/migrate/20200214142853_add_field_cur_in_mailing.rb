class AddFieldCurInMailing < ActiveRecord::Migration[6.0]
  def change
    add_column :mailings, :cur, :string
  end
end
