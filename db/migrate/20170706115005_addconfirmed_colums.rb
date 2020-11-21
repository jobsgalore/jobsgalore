class AddconfirmedColums < ActiveRecord::Migration[5.0]
  def up
    add_column :clients, :confirmation_token,   :string
    add_column :clients, :confirmed_at,         :datetime
    add_column :clients, :confirmation_sent_at, :datetime
    add_column :clients, :unconfirmed_email,    :string

    add_column :clients,  :failed_attempts,     :integer, default: 0, null: false
    add_column :clients,  :unlock_token,        :string
    add_column :clients,  :locked_at,           :datetime

    add_index  :clients, :confirmation_token,   :unique => true
    add_index :clients, :unlock_token,          unique: true
  end

  def down
    remove_index  :clients, :confirmation_token
    remove_index  :clients, :unlock_token

    remove_column :clients, :unconfirmed_email
    remove_column :clients, :confirmation_sent_at
    remove_column :clients, :confirmed_at
    remove_column :clients, :confirmation_token

    remove_column :clients, :failed_attempts
    remove_column :clients, :unlock_token
    remove_column :clients, :locked_at
  end
end
