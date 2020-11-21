class Mailing < ActiveRecord::Migration[5.2]
  def change
    create_table :mailings do |t|
      t.references :client, foreign_key: true
      t.string :message
      t.references :resume, foreign_key: true
      t.float :price
      t.jsonb :offices, array: true, default: []
      t.string :type_letter
      t.string :aasm_state
      t.timestamps
    end
  end

end
