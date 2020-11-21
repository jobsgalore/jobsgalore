class Order < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :algorithm, foreign_key: true
      t.references :product, foreign_key: true
      t.jsonb :params, null: false, default: '{}'
      t.references :payment, foreign_key: true
      t.string :aasm_state
      t.timestamps
    end
  end
end
