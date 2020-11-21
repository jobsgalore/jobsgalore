cache @obj do
  xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  xml.feed xmlns:"http://www.w3.org/2005/Atom" do
    xml.title PropertsHelper::TITLE, type:"text"
    xml.author do
      xml.name PropertsHelper::TITLE
    end
    xml.link href:root_url, rel:"self"
    xml.category "Jobs"
    xml.updated @obj.object.maximum('updated_at').strftime('%FT%T%:z')
    xml.id '1'
    xml.icon image_url("icon.png")
    xml.logo image_url("jg.png")
    xml.rights "© #{PropertsHelper::COMPANY} All rights reserved."
    @obj.each do |obj|
      xml.entry do
        xml.title obj.title, type:"text"
        xml.author do
          xml.name obj.company.name
        end
        xml.category term: obj.industry.name
        xml.category term: obj.location.suburb
        xml.category term: obj.location.state
        xml.link rel:"alternate", type:"text/html", href: job_url(obj)
        xml.id obj.id
        xml.updated obj.updated_at.strftime('%FT%T%:z')
        xml.published obj.created_at.strftime('%FT%T%:z')
        xml.summary "<p> #{obj.description_text}  </p>  <p>The post #{link_to obj.title, job_url(obj)} </p>" , type:"html"
      end
    end
  end
end