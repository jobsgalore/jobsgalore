class AddFieldFioOnEmailHrs < ActiveRecord::Migration[5.2]
  def change
    add_column :email_hrs, :fio, :string
  end
end
