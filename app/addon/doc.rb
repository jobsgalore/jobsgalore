require 'zip'
class Doc
  attr_reader :paragraphs
  attr_accessor :str
  module HTML
    def html_tag(name, options = {})
      content = options[:content]
      styles = options[:styles]

      html = "<#{name.to_s}"
      unless styles.nil? || styles.empty?
        styles_array = []
        styles.each do |property, value|
          styles_array << "#{property.to_s}:#{value};"
        end
        html << " style=\"#{styles_array.join('')}\""
      end
      html << ">"
      html << content if content
      html << "</#{name.to_s}>"
    end
  end

  class TextRun
    include HTML
    #include Elements::Element

    DEFAULT_FORMATTING = {
        italic:    false,
        bold:      false,
        underline: false
    }

    attr_reader :text
    attr_reader :formatting

    def initialize(node, document_properties = {})

      @node = node
      #@text_nodes = @node.xpath('w:t').map {|t_node| Elements::Text.new(t_node) }
      #@properties_tag = 'rPr'
      @node_text =@node.to_s
      @text = @node.xpath('w:t').text

      #@text       = parse_text || ''
      @formatting = parse_formatting || DEFAULT_FORMATTING
      #@document_properties = document_properties
      #@font_size = @document_properties[:font_size]
    end

    # Set text of text run
    def text=(content)
      if @text_nodes.size == 1
        @text_nodes.first.content = content
      elsif @text_nodes.empty?
        #new_t = Elements::Text.create_within(self)
        new_t.content = content
      end
    end

    def parse_formatting
      {
          italic:   !@node_text.scan(/<w:i\/>/).empty? ,#!@node.xpath('.//w:i').empty?,
          bold:     !@node_text.scan(/<w:b\/>/).empty? ,#!@node.xpath('.//w:b').empty?,
          underline: !@node_text.scan(/<w:u\/>/).empty?,#!@node.xpath('.//w:u').empty?
      }
    end

    # Return text as a HTML fragment with formatting based on properties.
    def to_html
      html = @text
      html = html_tag(:em, content: html) if italicized?
      html = html_tag(:strong, content: html) if bolded?
      styles = {}
      styles['text-decoration'] = 'underline' if underlined?
      # No need to be granular with font size down to the span level if it doesn't vary.
      #styles['font-size'] = "#{font_size}pt" if font_size != @font_size
      html = html_tag(:span, content: html, styles: styles) if styles.present?
      return html
    end

    def italicized?
      @formatting[:italic]
    end

    def bolded?
      @formatting[:bold]
    end

    def underlined?
      @formatting[:underline]
    end

    #def font_size
    #  size_tag = @node.xpath('w:rPr//w:sz').first
    #  size_tag ? size_tag.attributes['val'].value.to_i / 2 : @font_size
    #end
  end
###########################################################################################
#
#
  class Paragraph
    @@time=0
    include HTML
      attr_accessor :node
    def initialize(node, document_properties = {})
      @node = node
      #@document_properties = document_properties
      @alignment_tag = @node.xpath('.//w:jc').first
      @alignment_tag = (@alignment_tag ? @alignment_tag.attributes['val'].value : nil)
      #@font_size = @document_properties[:font_size]
    end

    def self.time
      @@time
    end
    # Set text of paragraph
    def text=(content)
      if text_runs.size == 1
        text_runs.first.text = content
      elsif text_runs.size == 0
        new_r = TextRun.create_within(self)
        new_r.text = content
      else
        text_runs.each {|r| r.node.remove }
        new_r = TextRun.create_within(self)
        new_r.text = content
      end
    end

    # Return paragraph as a <p></p> HTML fragment with formatting based on properties.
    def to_html
      html = ''
      text_runs.each do |text_run|
        html << text_run.to_html
      end
      styles = {}
      #styles = { 'font-size' => "#{font_size}pt" }
      styles['text-align'] = @alignment if @alignment
      html_tag(:p, content: html, styles: styles)
    end

    def text_runs
      t = Time.now
      puts @node
      puts "_______________________________________________________"
      rez = @node.xpath('w:r|w:hyperlink/w:r').map do  |r_node|
        e = Time.now
        elem = TextRun.new(r_node) #if r_node.present?
        @@time -=Time.now - e
        elem
      end
      @@time += Time.now - t
      rez
    end

    def aligned_left?
      ['left', nil].include?(@alignment)
    end

    def aligned_right?
      @alignment == 'right'
    end

    def aligned_center?
      @alignment == 'center'
    end

  end

  def initialize(path)
    t = Time.now
    #@str = decode(Nokogiri::XML Zip::File.open(path).read('word/document.xml')) #.scan(/(<w:t>.*?<\/w:t>)/).join
    @str = Nokogiri::XML Zip::File.open(path).read('word/document.xml')
    #Удаление шрифтов
    @str.xpath('//w:rFonts').remove
    #puts @str
    Rails.logger.debug "Инициализация = #{Time.now - t} s"
  end

  def paragraphs
    t = Time.now
    #разбивка по параграфам
    rez = @str.xpath('//w:document//w:body//w:p').map { |p_node| Paragraph.new(p_node)}
    Rails.logger.debug "Время разбора по параграфам = #{Time.now - t} s"
    rez
  end



  def to_html
    arr_par = self.paragraphs
    t = Time.now
    rez = arr_par.map{|t| t.to_html}.join
    Rails.logger.debug "Формируем HTML = #{Time.now - t} s | загрузка строк = #{Paragraph.time} s"
    rez
  end

  #def to_html(const)
  #  @str[0..const*1.7].gsub("w:t","p").force_encoding(Encoding::UTF_8)
  #end

end