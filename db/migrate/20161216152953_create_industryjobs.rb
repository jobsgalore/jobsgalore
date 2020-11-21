class CreateIndustryjobs < ActiveRecord::Migration[5.0]
  def change
    create_table :industryjobs do |t|
      t.references :industry, foreign_key: true
      t.references :job, foreign_key: true

      t.timestamps
    end
  end
end
