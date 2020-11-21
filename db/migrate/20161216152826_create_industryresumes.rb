class CreateIndustryresumes < ActiveRecord::Migration[5.0]
  def change
    create_table :industryresumes do |t|
      t.references :industry, foreign_key: true
      t.references :resume, foreign_key: true

      t.timestamps
    end
  end
end
