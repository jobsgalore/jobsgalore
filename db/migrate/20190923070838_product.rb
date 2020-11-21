class Product < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, default: 0
      t.jsonb :addition, null: false, default: '{}'
      t.timestamps
    end
  end
end
