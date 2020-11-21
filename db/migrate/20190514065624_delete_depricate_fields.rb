class DeleteDepricateFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :resumes, :permanent
    remove_column :resumes, :casual
    remove_column :resumes, :temp
    remove_column :resumes, :contract
    remove_column :resumes, :flextime
    remove_column :resumes, :fulltime
    remove_column :resumes, :remote
    remove_column :resumes, :parttime
    remove_column :jobs, :permanent
    remove_column :jobs, :casual
    remove_column :jobs, :temp
    remove_column :jobs, :contract
    remove_column :jobs, :flextime
    remove_column :jobs, :fulltime
    remove_column :jobs, :remote
    remove_column :jobs, :parttime
  end
end
