class CreateSkillsjobs < ActiveRecord::Migration[5.0]
  def change
    create_table :skillsjobs do |t|
      t.string :name, null:false
      t.references :level, foreign_key: true
      t.references :job, foreign_key: true

      t.timestamps
    end

    add_index :skillsjobs, :name
  end
end
