class Carearone < ActiveRecord::Migration[5.0]
  def change
    create_table :carearones do |t|
      t.string :title_job
      t.text :descriptions
      t.string :type
      t.string  :category
      t.string :location
    end
  end
end
