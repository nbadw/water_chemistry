# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.colincasey.com",
  :port => 26,
  :domain => "colincasey.com",
  :authentication => :login,
  :user_name => "test+colincasey.com",
  :password => "Testx3wp3"  
}
class ApplicationMailer < ActionMailer::Base
  self.template_root = File.join(RAILS_ROOT, 'app', 'mailers', 'views')  
  default_url_options[:host] = 'cri.nbwaters.unb.ca'
  default_url_options[:port] = 3000
end