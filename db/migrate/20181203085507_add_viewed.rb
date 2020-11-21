class AddViewed < ActiveRecord::Migration[5.2]
  def change
    create_table :vieweds do |t|
      t.integer  :client_id
      t.string :ip
      t.string  :lang
      t.string  :agent
      t.integer :doc_id
      t.string  :doc_type
      t.timestamps
    end

    create_table :respondeds do |t|
      t.integer  :client_id
      t.string :ip
      t.string  :lang
      t.string  :agent
      t.integer :doc_id
      t.string  :doc_type
      t.timestamps
    end

    remove_column :jobs, :responded
    remove_column :jobs, :viewed
    remove_column :resumes, :viewed


    add_index :respondeds, [:doc_id, :doc_type]
    add_index :vieweds, [:doc_id, :doc_type]
  end

end
