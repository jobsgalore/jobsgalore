class DeletedJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :deleted_jobs do |t|
      t.integer :original_id
      t.string :title
      t.references :location, foreign_key: true
      t.float :salarymin
      t.float :salarymax
      t.string :description
      t.date :begin
      t.references :company, foreign_key: true
      t.timestamps
    end

    add_index :deleted_jobs,:original_id
  end
end
