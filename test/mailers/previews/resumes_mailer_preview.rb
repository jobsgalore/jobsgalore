# Preview all emails at http://localhost:3000/rails/mailers/resumes_mailer
class ResumesMailerPreview < ActionMailer::Preview

  def add_resume
    ResumesMailer.add_resume(Resume.last)
  end

  def remove_resume
    resume = Resume.last
    ResumesMailer.remove_resume(email: resume.client.email, title:resume.title)
  end

  def turn_on_option
    ResumesMailer.turn_on_option("Urgent", Resume.find_by_id(43))
  end

  def turn_off_option
    ResumesMailer.turn_off_option("Urgent", Resume.find_by_id(43))
  end

  def send_to_employer
    letter = <<-TEXT
    <p>Hi,</p>
    <p>I\'m interested in the " +this.props.title.name+" job which I found on <a href=\"www.jobsgalore.eu\">Jobs Galore</a>. 
    I believe I have the appropriate experience for this role. Please contact me if you would like to discuss further.</p>
    <p>I look forward to hearing from you.</p>
    TEXT
    ResumesMailer.send_to_employer(Resume.last, Job.last, PropertsHelper::ADMIN, nil, letter)
  end

  def send_message
    letter = <<-TEXT
    <p>Hi,</p>
    <p>I\'m interested in the " +this.props.title.name+" job which I found on <a href=\"www.jobsgalore.eu\">Jobs Galore</a>. 
    I believe I have the appropriate experience for this role. Please contact me if you would like to discuss further.</p>
    <p>I look forward to hearing from you.</p>
    TEXT
    ResumesMailer.send_message(Resume.last, letter, Client.offset(rand(Client.count)).first)
  end

  def send_resume_without_clietn
    ResumesMailer.send_resume(223, 'mail@mail.eu', nil)
  end

  def send_resume_with_clietn
    ResumesMailer.send_resume(223, 'mail@mail.eu', true)
  end

end