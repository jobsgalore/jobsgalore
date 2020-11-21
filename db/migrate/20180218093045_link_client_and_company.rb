class LinkClientAndCompany < ActiveRecord::Migration[5.0]
  def change
    change_table :clients do |t|
      t.references :company
    end
  end


  def down
    remove_column :clients , :company
  end
end
