class EmailHr < ApplicationRecord
  belongs_to :company
  belongs_to :location

  def self.all_for_view
    sql = <<-SQL
    select
        e.id,
        'email' as "type_client",  
        c.name as "company", 
        e.fio  as "office", 
        e.main as "main", 
        l.suburb || ', '|| l.state as "location", 
        i.name as "industry", 
        c.recrutmentagency as "recrutmentagency"
    from email_hrs e
      full outer join locations l
        on l.id = e.location_id,
      companies c,
      industries i
    where e.company_id = c.id
      and c.industry_id = i.id
      and e.send_email = true
    order by c.name ASC, "location" ASC
    SQL

    ActiveRecord::Base.connection.exec_query(sql).to_a
  end
end