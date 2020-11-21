module ResumeHelper
  def meta_for_resume(resume)
     meta_head({ description: resume.description_meta,
                  title: resume.title,
                  keywords: resume.keywords,
                  url: resume_url(resume),
                  canonical: resume_url(resume),
                  published: resume.updated_at})
  end

  def social_button_resume(resume)
    social_share_button_tag(resume.title,
                            url: resume_url(resume),
                            desc:resume.description_text,
                            text_in_window: 'Email this resume to yourself or a friend',
                            post_url: send_resume_path,
                            params: {resume: resume.id}.to_json
    )
  end

end