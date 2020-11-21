class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :postcode
      t.string :suburb
      t.string :state

      t.timestamps
    end
  end
end
