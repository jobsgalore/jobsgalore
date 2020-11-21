#step 1
class DeleteMediumBridg < ActiveRecord::Migration[5.0]
  def change
    change_table :jobs do |t|
      t.references :industry, foreign_key: true
    end
    change_table :resumes do |t|
      t.references :industry, foreign_key: true
    end
    change_table :companies do |t|
      t.references :industry, foreign_key: true
    end
  end
end
