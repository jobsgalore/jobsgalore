class AddColumsInClientForLinkedin < ActiveRecord::Migration[5.2]
  def change
    change_table :clients do |t|
      t.string :provider
      t.string :uid
    end
  end
end
