class AddColumLocationInResumes < ActiveRecord::Migration[5.0]
  def change
    change_table :resumes do |resume|
      resume.references :location, foreign_key: true
    end
  end

  def down
    remove_column :resumes, :location
  end
end
