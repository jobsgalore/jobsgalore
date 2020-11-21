class UrlToSources < ActiveRecord::Migration[5.2]
  def change
    drop_table :carearones
    drop_table :temporaries
    drop_table :industrycompanies
    drop_table :industryjobs
    drop_table :industryresumes
    drop_table :languageresumes
    drop_table :languages
    drop_table :responsibles
    drop_table :skillsjobs
    drop_table :skillsresumes
    drop_table :levels
    remove_column :jobs, :education_id
    add_column :jobs, :sources, :string
    add_column :jobs, :apply, :string
    add_column :resumes, :sources, :string
    add_column :clients, :sources, :string
    drop_table :educations
  end
end
