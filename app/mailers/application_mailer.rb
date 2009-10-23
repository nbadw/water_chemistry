# encoding: utf-8

class ApplicationMailer < ActionMailer::Base
  self.template_root = File.join(RAILS_ROOT, 'app', 'mailers', 'views')
  default_url_options[:host] = 'cri-linux.nbwaters.unb.ca'
end
