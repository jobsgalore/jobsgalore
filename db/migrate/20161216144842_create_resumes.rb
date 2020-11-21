class CreateResumes < ActiveRecord::Migration[5.0]
  def change
    create_table :resumes do |t|
      t.string :desiredjobtitle, null:false
      t.float :salary
      t.boolean :permanent
      t.boolean :casual
      t.boolean :temp
      t.boolean :contract
      t.boolean :fulltime
      t.boolean :parttime
      t.boolean :flextime
      t.boolean :remote
      t.string :abouteme
      t.references :client, foreign_key: true

      t.timestamps
    end
    add_index :resumes, :salary
    add_index :resumes, :updated_at
    add_index :resumes, :created_at
  end
end
