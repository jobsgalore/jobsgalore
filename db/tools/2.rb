require 'spreadsheet'
book = Spreadsheet.open("book.xls")
i=1
j=0
new_book = Spreadsheet::Workbook.new
new_book.create_worksheet(name:'0')
book.worksheet(0).each do |str|
  new_book.worksheet(0).insert_row(0,str)
  if i%10==0
    new_book.write("test#{j}.xls")
    new_book = Spreadsheet::Workbook.new
    new_book.create_worksheet(name:'0')
    j+=1
  end
  i+=1
end
new_book.write("test#{j}.xls")