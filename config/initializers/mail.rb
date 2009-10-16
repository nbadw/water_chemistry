require "smtp_tls"

config_file = "#{RAILS_ROOT}/config/smtp_gmail.yml"
raise "Sorry, you must have #{config_file}" unless File.exists?(config_file)
config_options = YAML.load_file(config_file)

# Email settings
ActionMailer::Base.delivery_method = :smtp
# Use the following account for email delivery
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}.merge(config_options) # Configuration options override default options

# ActionMailer settings
class ApplicationMailer < ActionMailer::Base
  self.template_root = File.join(RAILS_ROOT, 'app', 'mailers', 'views')  
  default_url_options[:host] = 'cri.nbwaters.unb.ca'
  default_url_options[:port] = 3000
end