# Configure dkim globally (see above)
Dkim::domain      = 'jobsgalore.eu  '
Dkim::selector    = 'email'
begin
  Dkim::private_key = open(Rails.root.join('key/private.pem')).read #OpenSSL::PKey::RSA.new(ENV['DM_KIT_KEY'].gsub("\\n", "\n")) #open(Rails.root.join('key/private.pem')).read
rescue
  Dkim::private_key = OpenSSL::PKey::RSA.new(ENV['DM_KIT_KEY'].gsub("\\n", "\n"))
end
#

# This will sign all ActionMailer deliveries
ActionMailer::Base.register_interceptor(Dkim::Interceptor)