class LinkedInClient

  #TODO It do not work
  def linkedin_to_h(auth)
    begin
    if auth
      Rails.logger.debug(auth.to_json)
      experience = auth&.extra&.raw_info&.positions[:values]&.last
      summary = ''
      summary = auth&.extra&.raw_info&.summary.split("\n").compact.map{|t| "<p>#{t}</p>"}.join if auth.extra.raw_info.summary
      local = Location.search((auth.extra.raw_info.location.name.delete("!.,:*&()'`\"’").split(" ").map {|t| t=t+":*"}).join("|")).first
      if experience
        location = "<p><strong> Location: </strong>"+ experience.location.name+"</p>" if experience.location.name
        date_start = "<p>#{Date.new(experience.startDate.year, experience.startDate.month).strftime('%b %Y')} - Present</p>" if experience.startDate
        experience_summary = experience.summary.split("\n").compact.map{|t| "<p>#{t}</p>"}.join if experience.summary
        experience_title = "<p><strong>#{experience.title}</strong></p>" if experience.title
        experience_company_name = "<p><strong>#{experience.company.name}</strong></p>" if experience.company&.name
        experience_first = "<h3>Experience</h3><hr>"+experience_title.to_s + experience_company_name.to_s + date_start.to_s+location.to_s+experience_summary.to_s+"<hr>"
        summary += experience_first.to_s
      end
      {title: auth.extra.raw_info.headline,
       industry_id: Industry.find_by_linkedin(auth.extra.raw_info.industry).id,
       location_id: (local ? local.id : Location.default.id),
       location_name: (local ? local.name : Location.default.name),
       description: summary,
       sources: auth.extra.raw_info.publicProfileUrl}
    end
    rescue
      nil
    end
  end

  def get_profile(token)
    Rails.logger.debug("LinkedInClient.get_profile token=  #{token.to_s}")
    if token
      url = URI.parse('https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(originalImage~:playableStreams))')
      connect = Net::HTTP::Get.new(url.to_s)
      connect.add_field(:authorization, "Bearer "+token.to_s)
      connect.add_field(:connection, 'Keep-Alive')
      connect.add_field('x-li-format', 'json')
      https =  Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      res = https.start {|http|
        http.request(connect)
      }
      OmniAuth::AuthHash.new({"extra":{"raw_info":JSON.parse(res.body)}})
    end
  end
end
