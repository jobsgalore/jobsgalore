class CreateIndustryexperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :industryexperiences do |t|
      t.references :industry, foreign_key: true
      t.references :experience, foreign_key: true

      t.timestamps
    end
  end
end
