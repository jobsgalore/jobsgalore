class ClientsForInvate
  def call
    sql =<<-SQL
            select email
            from clients 
            where clients.character = 'applicant'
                and send_email = true
                and clients.id not in (select client_id from resumes)
    SQL
    connect = ActiveRecord::Base.connection
    result = connect.exec_query(sql).rows.flatten
    connect.close
    result
  end
end