class AddColumToLocations < ActiveRecord::Migration[5.0]
  def up
    change_table :locations do |t|
      t.references :parent, index:true
      t.tsvector :fts
      t.index :fts, using: "gin"
    end
    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON locations FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', suburb, postcode, state
      );
    SQL
    #execute'create index fts_index on locations using gin (fts);'
    #execute 'UPDATE locations SET fts=
     #       setweight( coalesce( to_tsvector(\'english\', postcode),\'\'),\'B\') || \' \' ||
    #        setweight( coalesce( to_tsvector(\'english\', suburb),\'\'),\'A\') || \' \' ||
     #       setweight( coalesce( to_tsvector(\'english\', state),\'\'),\'D\');'
    now = Time.current.to_s(:db)
    update("UPDATE locations SET updated_at = '#{now}'")
  end
  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON products
    SQL
    remove_index :locations, :parent
    remove_index :locations, :parent
    remove_column :locations, :fts
    remove_column :locations, :fts
  end
end