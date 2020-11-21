module IndustryHelper
  def link_industry(name = nil, industry = nil, type= nil, html_options = nil, &block)
    if industry.present?
      link_to name , "/#{industry.id}/#{type.code}", html_options, &block
    end
  end
end