class AddFieldSendEmailInClientforalert < ActiveRecord::Migration[6.0]
  def change
    add_column :clientforalerts, :send_email, :boolean, default: true
  end
end
