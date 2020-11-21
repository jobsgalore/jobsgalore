class AddFieldApplyesInJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :responded, :jsonb, array:true, default: []
  end
end
