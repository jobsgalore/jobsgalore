class AddUrgent < ActiveRecord::Migration[5.0]
  def change
    change_table :resumes do |elem|
      elem.date :urgent
    end

    change_table :jobs do |elem|
      elem.date :urgent
    end
  end

  def down
    remove_column :resumes, :urgent
    remove_column :jobs, :urgent
  end
end
