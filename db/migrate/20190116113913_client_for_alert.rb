class ClientForAlert < ActiveRecord::Migration[5.2]
  def change
    create_table :clientforalerts do |t|
      t.string :email, unique: true
      t.string :key
      t.integer :location_id,  default: nil

      t.timestamps
    end
  end
end
