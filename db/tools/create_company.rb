require 'csv'
require 'json'

arr_company=[]
CSV.open("company.csv") do |file|
  file.each do |str|
    arr_company<<str[0] if str[0]!=nil
  end
end
words = []
File.open("words.txt") do |file|
  words=file.readlines
end
puts words
arr = []
arr_company.each do |elem|
  recrutmentagency = [false, false, false, true].sample
  description =''
  Random.rand(50).times do
    description += words[Random.rand(words.size)].delete("\n")+' '
  end
  arr << {"name":elem,"size":"nil","location":"nil","recrutmentagency": recrutmentagency,"description":description}
end
File.open("3Company.json",'w') do |output_file|
  output_file.puts JSON.generate Hash["Company",arr]
end
