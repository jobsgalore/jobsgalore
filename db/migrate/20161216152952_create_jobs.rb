class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.references :location, foreign_key: true
      t.float :salarymin
      t.float :salarymax
      t.boolean :permanent
      t.boolean :casual
      t.boolean :temp
      t.boolean :contract
      t.boolean :fulltime
      t.boolean :parttime
      t.boolean :flextime
      t.boolean :remote
      t.string :description
      t.references :company, foreign_key: true
      t.references :education, foreign_key: true
      t.string :career

      t.timestamps
    end
    add_index :jobs,:salarymin
    add_index :jobs,:salarymax
    add_index :jobs, :updated_at
    add_index :jobs, :created_at
  end
end
