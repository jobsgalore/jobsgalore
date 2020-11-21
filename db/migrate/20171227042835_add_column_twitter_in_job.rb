class AddColumnTwitterInJob < ActiveRecord::Migration[5.0]
    def up
      change_table :jobs do |t|
        t.boolean :twitter
      end
    end
    def down
      remove_column :jobs , :twitter
    end
end
