# Preview all emails at http://localhost:3000/rails/mailers/client_mailer/
class ClientMailerPreview < ActionMailer::Preview
  def send_invite_for_posting_resume
    ClientMailer.send_invite_for_posting_resume(PropertsHelper::ADMIN)
  end
end