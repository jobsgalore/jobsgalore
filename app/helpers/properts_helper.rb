#TODO Убрать. Переделать на переменные окружения
module PropertsHelper
  if ENV['RAILS_ENV'] == 'test'
    COMPANY = ''
    EMAIL = ''
  end

  Propert.all.each do |prop|
      if prop.code.present? and prop.code != 'bots'
        eval("#{prop.code.upcase} = \"#{prop.value}\"")
      end
  end

end
