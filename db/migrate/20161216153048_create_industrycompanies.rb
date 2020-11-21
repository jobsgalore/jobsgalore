class CreateIndustrycompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :industrycompanies do |t|
      t.references :industry, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
