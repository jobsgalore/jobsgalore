class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :email, null: false, default: ""
      t.string :phone
      t.string :password
      t.boolean :resp, null: false, default: false
      t.string :photo_uid
      t.boolean :gender
      t.references :location, foreign_key: true

      t.timestamps
    end
    add_index :clients, :email ,                unique: true

  end
end
