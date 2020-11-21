class CreateIndustries < ActiveRecord::Migration[5.0]
  def change
    create_table :industries do |t|
      t.string :name, null:false
      t.references  :industry, foreign_key: true
      t.integer :level, null:false

      t.timestamps
    end
    add_index :industries, :name
  end
end