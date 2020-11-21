module EmailHelper

  def title_email
    "font-family: 'Google Sans',Roboto,RobotoDraft,Helvetica,Arial,sans-serif;border-bottom: thin solid #dadce0; color: rgba(0,0,0,0.87); line-height: 32px; padding-bottom: 24px;text-align: center; word-break: break-word;"
  end

  def h1_email
    "font-size: 24px;"
  end

  def h3_email
    "font-size: 18px;"
  end

  def body_email
    "font-family: Roboto-Regular,Helvetica,Arial,sans-serif; font-size: 14px; color: rgba(0,0,0,0.87); line-height: 20px;padding-top: 20px; text-align: center;"
  end

  def button_email
    "padding-top: 32px;text-align: center;"
  end

  def link_email
    "font-family: 'Google Sans',Roboto,RobotoDraft,Helvetica,Arial,sans-serif; line-height: 16px; color: #ffffff; font-weight: 400; text-decoration: none;font-size: 14px;display:inline-block;padding: 10px 24px;background-color: #4184F3; border-radius: 5px; min-width: 90px;"
  end

  def space_email(hr = false)
    content_tag(:div,"",style:"height:13px; #{hr ? "border-bottom: thin solid #dadce0;" : nil}")
  end

  def message_email
    "text-align: left;"
  end
end