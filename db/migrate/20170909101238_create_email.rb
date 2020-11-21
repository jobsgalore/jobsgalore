class CreateEmail < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :email
    end
  end
end
