class AddOthersName < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :names, :string, array:true
  end
end
