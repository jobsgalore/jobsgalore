class Algorithm < ActiveRecord::Migration[6.0]
  def change
    create_table :algorithms do |t|
      t.string :code, null: false
      t.timestamps
    end
  end
end
