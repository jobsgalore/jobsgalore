class AddFullSearchInJobsResumesCompanies < ActiveRecord::Migration[5.0]
  def up
    change_table :companies do |t|
      t.tsvector :fts
      t.index :fts, using: "gin"
    end
    change_table :jobs do |t|
      t.tsvector :fts
      t.index :fts, using: "gin"
    end
    change_table :resumes do |t|
      t.tsvector :fts
      t.index :fts, using: "gin"
    end
    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON companies FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', name, description
      );
    SQL

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON jobs FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', title, description, career
      );
    SQL

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON resumes FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', desiredjobtitle, abouteme
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE resumes SET updated_at = '#{now}'")
    update("UPDATE jobs SET updated_at = '#{now}'")
    update("UPDATE companies SET updated_at = '#{now}'")
  end
  def down

    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON resumes
    SQL
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON jobs
    SQL
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON companies
    SQL
    remove_index :resumes, :fts
    remove_column :resumes, :fts

    remove_index :jobs, :fts
    remove_column :jobs, :fts

    remove_index :companies, :fts
    remove_column :companies, :fts
  end
end