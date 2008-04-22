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

