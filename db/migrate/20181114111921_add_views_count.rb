class AddViewsCount < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :viewed_count, :integer
    add_column :resumes, :viewed_count, :integer
  end
end
