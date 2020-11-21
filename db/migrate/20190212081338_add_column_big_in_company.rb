class AddColumnBigInCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :big, :boolean, null: false,  default: false
  end
end
