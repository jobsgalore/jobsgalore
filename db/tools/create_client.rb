require 'csv'
require 'json'

begin
  puts "Загрузка первого файла"
  surname=[]
  CSV.open("surname.csv") do |input_file|
    input_file.each do |elem|
      surname << elem[0]
    end
  end
  puts surname.length

  puts "Загрузка второго файла"
  arrjson = nil
  File.open("name.json") do |elem|
    arrjson=elem.readlines
  end


  name = []
  arrjson.each do |json|
    name << JSON.parse(json[1..json.length])
  end

  puts "Создание структуры"
  result=[]
  i=1 #Объем клиентов.
  while i<=1
    surname.each do |t|
      firstname = name[Random.rand(name.size)]["name"]
      email="#{firstname}.#{t.to_s}@#{['mail.ru','hotmail.com','yahoo.com','yandex.ru','mail.com'].sample}"
      phone=''
      11.times do
        phone+=Random.rand(10).to_s
      end
      gender = [false,true].sample
      result<<{"firstname": firstname, "lastname":t, "email":email, "phone": phone,"gender": gender}
    end
    i+=1
  end
  File.open("2Client.json",'w') do |output_file|
    output_file.puts JSON.generate Hash["Client",result]
  end

rescue
  puts "Error: #{$!}"
end