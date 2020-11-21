class RemoveFieldsFromJobs < ActiveRecord::Migration[6.0]
  def change
    remove_column :jobs, :career
    remove_column :jobs, :twitter

  end

end


