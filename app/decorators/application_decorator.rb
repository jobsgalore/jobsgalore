class ApplicationDecorator < Draper::Decorator

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def description_meta
    @description_meta ||= description_text
  end

  def title
    @title ||= object.title&.html_safe
  end

  def description_text
    @description_text ||= markdown_to_text(object.description, 300)
  end

  def description_html
    @description_html ||= object.description
  end

  def render_description
    (@render_description ||= self.description_html&.gsub('<img',"<img class=\"img-thumbnail center-block\"")&.gsub('<a',"<a rel=\"nofollow\""))
  end

  def posted_date
    @date ||= object.created_at.strftime("%d %B %Y")
  end

  def close_date
    @close ||= object.dt_close.strftime("%d %B %Y")
  end
  private
  def markdown_to_keywords (arg)
    if arg
      keys = markdown_to_text(arg, 400).split(' ').map do |key|
        key.delete!(',')
        key = nil unless key&.length > 3
        key
      end
      keys.compact.uniq.join(', ')
    end
  end

  def markdown_to_text (arg, truncate=nil)
    if arg
      arg = arg[0..truncate * 2] if truncate
      text = Nokogiri::HTML(arg).text.squish
      if truncate
        text = text.truncate(truncate, separator: ' ',omission: '')
      end
    else
      ''
    end
  end

end
