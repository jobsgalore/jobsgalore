class DeleteNotUniqClient
  def call
    sql = 'delete from clientforalerts where clientforalerts.email in (select c.email from clients c)'
    connect = ActiveRecord::Base.connection
    connect.exec_query(sql)
    connect.close
  end
end