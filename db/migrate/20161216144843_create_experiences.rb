class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.string :employer, null:false
      t.references :location, foreign_key: true
      t.string :site
      t.string :titlejob, null:false
      t.date :datestart
      t.date :dateend
      t.string :description
      t.references :resume, foreign_key: true

      t.timestamps
    end
  end
end
