class ProductMultiCurrency < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :price
    add_column :products ,:price,:jsonb, null: false, default: '{}'
  end
end
