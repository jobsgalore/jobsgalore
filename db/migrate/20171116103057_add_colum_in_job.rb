class AddColumInJob < ActiveRecord::Migration[5.0]
    def up
      change_table :jobs do |t|
        t.date :close
      end
    end
    def down
      remove_column :jobs , :close
    end
end
