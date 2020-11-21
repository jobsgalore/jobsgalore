class UpdateTrigers < ActiveRecord::Migration[5.2]
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
      CREATE FUNCTION companies_trigger() RETURNS trigger AS $$
      begin
        new.fts :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'D');
        return new;
      end
      $$ LANGUAGE plpgsql;
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON companies FOR EACH ROW EXECUTE PROCEDURE companies_trigger();
    SQL

    execute <<-SQL
      CREATE FUNCTION jobs_trigger() RETURNS trigger AS $$
      begin
        new.fts :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'D');
        return new;
      end
      $$ LANGUAGE plpgsql;
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON jobs FOR EACH ROW EXECUTE PROCEDURE jobs_trigger();
    SQL

    execute <<-SQL
    CREATE FUNCTION resumes_trigger() RETURNS trigger AS $$
    begin
      new.fts :=
          setweight(to_tsvector('pg_catalog.english', coalesce(new.desiredjobtitle,'')), 'A') ||
          setweight(to_tsvector('pg_catalog.english', coalesce(new.abouteme,'')), 'D');
      return new;
    end
    $$ LANGUAGE plpgsql;
      CREATE TRIGGER tsvectorupdate before INSERT OR UPDATE
      ON resumes FOR EACH ROW EXECUTE PROCEDURE resumes_trigger();
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
