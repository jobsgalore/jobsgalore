class OfficeDocumentToHtml
  include Interactor
  COUNT = 3600
  def call
    #begin
      file = context.params[:file]
      document = LazyHash.new("application/pdf"=>->{to_html(PDF::Reader.new(file.to_io).pages)},
                              "application/vnd.openxmlformats-officedocument.wordprocessingml.document"=>->{html_from_docx(file.to_io)})
      context.result = {description: context.html=document[file.content_type]}
    #rescue
     # Rails.logger.info("Error Document: #{$!}")
      #context.result = {description:nil}
    #end
  end

  private
  # TODO все конверторы или отдельным сервисом или серез с\go

  def to_html(party)
    i = 0
    a=[]
    party.each do |p|
      i +=p.text.length
      p.text.gsub("<","&lt;").gsub(">","&gt;").split("\n").compact.each do |str|
        a.push("<p>#{str}</p>")
      end
      break if i>=COUNT
    end
    a.join
  end

  def html_from_docx(arg)
    t = Time.now
    Rails.logger.debug("Начинаем преобразовывать в html")
    #res = Docx::Document.open(arg).to_html
    res = Doc.new(arg).to_html
    Rails.logger.debug("Закончили преобразование в html.  Время #{Time.now - t} s")
    res
  end


end