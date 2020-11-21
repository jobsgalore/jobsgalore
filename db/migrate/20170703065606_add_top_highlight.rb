class AddTopHighlight < ActiveRecord::Migration[5.0]
  def up
    change_table :resumes do |elem|
      elem.date :highlight
      elem.date :top
      elem.date :urgent
    end

    change_table :jobs do |elem|
      elem.date :highlight
      elem.date :top
      elem.date :urgent
    end
  end

  def down
    remove_column :resumes, :highlight
    remove_column :resumes, :top
    remove_column :jobs, :highlight
    remove_column :jobs, :top
    remove_column :resumes, :urgent
    remove_column :jobs, :urgent
  end
end
