module CompanyHelper

  def jobs_of_company (object)
    if object.jobs_count>0
      content_tag :h3 do
        link_to "#{object.jobs_count} jobs at #{object.name}", jobs_at_company_path(object)
      end
     end
  end

  def company_summary (object)
    html = ActiveSupport::SafeBuffer.new
    html += if object.site
              content_tag( :p, link_to(object.site, object.site, rel:"nofollow"))
           end
    html +=content_tag(:p) do
      p = content_tag :strong, "Location: "
      p+= content_tag(:span, class: "hidden-xs hidden-md hidden-lg hidden-sm", itemprop:"location", :itemscope=>true , itemtype:"http://schema.org/PostalAddress" ) do
        span = content_tag(:span,object.location.suburb ,itemprop:"addressLocality")
        span += content_tag(:span,object.location.state ,itemprop:"addressRegion")
      end
      p += link_location(object.location.name, object.location, Objects::COMPANIES, class: 'text-warning')
    end
    html +=if object.size
             content_tag(:p) do
               p = content_tag :strong, "Size: "
               p+= "#{object.size.size}".html_safe
             end
           end
    html +=if object.recrutmentagency?
             content_tag(:p) do
               content_tag :strong, "Recruitment agency "
             end
           end
    html +=if object.industry
             ind = content_tag(:p) do
               content_tag :strong, "Industry: "
             end
             ind +=content_tag( :ul) do
               content_tag(:li , link_industry(object.industry.name, object.industry, Objects::COMPANIES, class: 'text-success'))
             end
           end
  end

  def company_logo(object, width, height, **option)
    if object.logo.blank? || ENV["RAILS_ENV"]!='production'
      content_tag(
          :div,
          '',
          #"data-src": data_src,
          class: option[:class] ? option[:class]  : "text-center img-thumbnail center-block avatar",
          style: "background-image: url('#{image_url("company_profile.jpg")}'); background-size: contain; width: #{width}; height: #{height};")
    else
      image_tag(
          Dragonfly.app.remote_url_for(object.logo_uid),
          height: height,
          width: width,
          alt: "#{object.name} by #{PropertsHelper::COMPANY}",
          title: "#{object.name} by #{PropertsHelper::COMPANY}",
          class: "text-center img-thumbnail center-block avatar" ,
          option: option
      )
    end
  end

  def buttons( class_name)
    content_tag(:div,class:"row") do
      buttons  = content_tag(:div, class:class_name) do
        div = content_tag :a,"Contact", class: "btn btn-primary btn-block", href: contacts_of_companies
        div += content_tag(:p)
      end
      buttons  = content_tag(:div, class:class_name) do
        div = button_tag "Back", class: "btn btn-success btn-block", onclick:"history.back()"
        div += content_tag(:p)
      end
    end
  end


  def meta_for_company(company)
    meta_head(  title:company.name,
                description: company.description_meta,
                keywords: company.keywords,
                url: company_url(company),
                canonical: company_url(company),
                image: company.logo_url)
  end

  def social_button_company(company)
    social_share_button_tag(company.name,
                            url: company_url(company),
                            desc:company.description_text,
                            allow_sites: SocialShareButtonStrategy::WITHOUT_EMAIL

    )
  end


end
