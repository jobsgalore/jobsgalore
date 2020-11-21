class CreateResponsibles < ActiveRecord::Migration[5.0]
  def change
    create_table :responsibles do |t|
      t.references :company, foreign_key: true
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
