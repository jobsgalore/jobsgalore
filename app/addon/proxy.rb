require 'net/http'

class Proxy
  def connect(arg = 'https://rbc.ru')
    arg= {url: arg}
    flag = true
    respond = nil
    i = 0
    while flag and i<9 do
      begin
        i +=1
        uri = URI('https://pacific-tundra-23056.herokuapp.com/open?' +arg.to_query)
        respond = Net::HTTP.get(uri).force_encoding('UTF-8')
        flag = false
      rescue
        puts("Ошибка #{$!}")
        flag = true
      end
    end
    respond
  end

  def redirect(arg)
    if arg
      arg= {url: arg}
      flag = true
      respond = nil
      i = 0
      while flag and i<3 do
        begin
          i +=1
          uri = URI('https://pacific-tundra-23056.herokuapp.com/redirect?' +arg.to_query)
          respond = Net::HTTP.get(uri).force_encoding('UTF-8')
          flag = false
        rescue
          puts("Ошибка #{$!}")
          flag = true
        end
      end
      respond
    end
  end

end