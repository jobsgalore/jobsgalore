class AddCountJobsInLocation < ActiveRecord::Migration[5.2]
  def change
      add_column :locations, :counts_jobs, :integer
  end
end
