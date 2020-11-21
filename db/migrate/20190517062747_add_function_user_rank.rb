class AddFunctionUserRank < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      create FUNCTION user_rank(in field tsvector, in query_full text, in query text, in mode_execute text[]) returns float4 AS $body$
      DECLARE rank_by_query float4;
      begin
        rank_by_query := 0;
        if (rank_by_query = 0 and ARRAY['phrase'] <@ mode_execute) then
          rank_by_query := ts_rank_cd(field, phraseto_tsquery(query_full))*1000;
        end if;
        if (rank_by_query = 0 and ARRAY['plain'] <@ mode_execute) then
          rank_by_query := ts_rank_cd(field, plainto_tsquery(query_full))*50;
        end if;
        if (rank_by_query = 0 and ARRAY['none'] <@ mode_execute) then
          rank_by_query := ts_rank_cd(field, to_tsquery(query));
        end if;
        return rank_by_query;
      end;
      $body$ LANGUAGE plpgsql;
    SQL
  end
end
