module ApplicationHelper
  ALL = "highlight urgent"
  HIGHLIGHT = "highlight"
  URGENT = "urgent"

  def title(text)
    content_for :title, text
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  def noindex
    content_for :noindex, true
  end

  def image_bg(url, bgsize, width, height, **option)
=begin
    if !option[:autoload]
      default_image = "url('#{url}')"
      data_src = nil
    else
      default_image = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='
      data_src = url
    end
=end
    content_tag(
        :div,
        '',
        #"data-src": data_src,
        class: "#{option[:class] ? (option[:class].to_s + ' b-lazy')  : "text-center img-thumbnail center-block avatar b-lazy"}",
        style: "background-image: url('#{url}'); background-size: #{bgsize}; width: #{width}; height: #{height};")
  end



  def meta_head(arg={})
    title arg[:title]
    meta_tag "description",   arg[:description]
    meta_tag "keywords", arg[:keywords]
    meta_tag "og:type", arg[:type] ? arg[:type] : "article"
    meta_tag "og:title", arg[:title]
    meta_tag "og:description", arg[:description]
    meta_tag "og:url", arg[:url]
    meta_tag "og:image", arg[:image]
    meta_tag "article:published_time", arg[:published]
    meta_tag "twitter:card",arg[:card]
    meta_tag "twitter:site",arg[:user]
    meta_tag "twitter:title",arg[:title]
    meta_tag "twitter:description",arg[:description]
    meta_tag "twitter:image:src",arg[:image]
    meta_tag "canonical",arg[:canonical]
  end

  def class_extras(object)
    if object.highlight and object.urgent
      ALL
    elsif not object.highlight and object.urgent
      URGENT
    elsif object.highlight and not object.urgent
      HIGHLIGHT
    else
      ""
    end
  end

  def will_paginate_mini(objects)
    will_paginate objects, {renderer: BootstrapPagination::Rails, inner_window:1, outer_window:0, previous_label:'&#8592;', next_label: '&#8594;'}
  end

  def sort_by_search(query)
    content_tag :h4 do
      h4 = "Sort by: ".html_safe
      h4 += if (query[:main_search][:sort]=="date")
              query[:main_search][:sort] = :relevance
              text = link_to :relevance, search_url(query)
              text +=" | date".html_safe
            else
              query[:main_search][:sort] = :date
              text = "relevance | ".html_safe
              text +=link_to :date, search_url(query)
            end
    end
  end

  def original_url
    "?url=#{request.original_url}"
  end

  def search_for_main_page
    react_component("Search", {name: name, key: key, url_industries: industries_url, search: search, show: true})
  end

  def social_button_in_invite
    social_share_button_tag('JobsGalore.eu',
                            url: root_url,
                            desc: 'JobsGalore is a job search aggregator in Australia. Find jobs and career related information. Find your dream job. Make job search easy with us!',
                            allow_sites: SocialShareButtonStrategy::WITHOUT_EMAIL

    )
  end

end
