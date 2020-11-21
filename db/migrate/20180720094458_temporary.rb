class Temporary < ActiveRecord::Migration[5.2]
  def change
    create_table :temporaries do |t|
      t.string :session
      t.json :object, array: true, default: []
      t.timestamps
    end
  end
end
