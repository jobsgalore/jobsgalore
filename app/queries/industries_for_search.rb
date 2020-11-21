class IndustriesForSearch
  def call
    default_value = [{'code': 0, 'name': 'Select category'}]
    sql = 'select id as "code", name from industries'
    connect = ActiveRecord::Base.connection
    default_value + connect.exec_query(sql).to_a
  end
end