class Experiment < ActiveRecord::Migration[6.0]
  def change
    create_table :experiments do |t|
      t.string :name
      t.string :variant
      t.jsonb :params, null: false, default: '{}'
      t.timestamps
    end
  end
end
