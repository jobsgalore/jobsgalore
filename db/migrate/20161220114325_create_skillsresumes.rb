class CreateSkillsresumes < ActiveRecord::Migration[5.0]
  def change
    create_table :skillsresumes do |t|
      t.string :name, null:false
      t.references :level, foreign_key: true
      t.references :resume, foreign_key: true

      t.timestamps
    end
    add_index :skillsresumes, :name
  end
end
