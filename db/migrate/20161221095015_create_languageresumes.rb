class CreateLanguageresumes < ActiveRecord::Migration[5.0]
  def change
    create_table :languageresumes do |t|
      t.references :resume, foreign_key: true
      t.references :language, foreign_key: true
      t.references :level, foreign_key: true

      t.timestamps
    end
  end
end
