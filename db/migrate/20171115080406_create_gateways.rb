class CreateGateways < ActiveRecord::Migration[5.0]
  def change
    create_table :gateways do |t|
      t.references :company, foreign_key: true
      t.references :client, foreign_key: true
      t.references :location, foreign_key: true
      t.references :industry, foreign_key: true
      t.string :script

      t.timestamps
    end
  end
end
