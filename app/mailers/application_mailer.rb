# encoding: utf-8

class ApplicationMailer < ActionMailer::Base
  self.template_root = File.join(RAILS_ROOT, 'app', 'mailers', 'views')
  default_url_options[:host] = 'cri.nbwaters.unb.ca'
  default_url_options[:port] = 3000
end
