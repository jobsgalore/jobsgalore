class UpdateEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :arr, :jsonb, array:true, default: []
  end
end
