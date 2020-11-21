class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.text :params
      t.integer :product_id
      t.integer :kind
      t.integer :kindpay
      t.string :status
      t.string :transaction_id
      t.timestamps
    end
  end
end
