class CreateProperts < ActiveRecord::Migration[5.0]
  def change
    create_table :properts do |t|
      t.string :code
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
