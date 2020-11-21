class NotVerificationClients < ActiveRecord::Migration[5.2]
  def change
    create_table :email_hrs do |t|
      t.string :email, null: false, default: ''
      t.references :company, foreign_key: true
      t.string :phone
      t.boolean :send_email
      t.boolean :contact
      t.references :location, foreign_key: true
      t.timestamps
    end
    add_index :email_hrs, :email, unique: true
  end
end
