class NewTrigers < ActiveRecord::Migration[5.0]
  def up
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

      execute <<-SQL
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON companies FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', name, description
      );
      SQL

      execute <<-SQL
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON jobs FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', title, description
      );
      SQL

      execute <<-SQL
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON resumes FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', desiredjobtitle, abouteme
      );
      SQL
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

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON companies FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', name, description
      );
    SQL

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON jobs FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', title, description
      );
    SQL

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON resumes FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        fts, 'pg_catalog.english', desiredjobtitle, abouteme
      );
    SQL
  end
end
