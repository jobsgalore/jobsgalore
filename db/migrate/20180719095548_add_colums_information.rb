class AddColumsInformation < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :viewed, :json, array:true, default: []
    add_column :resumes, :viewed, :json, array:true, default: []
  end
end
