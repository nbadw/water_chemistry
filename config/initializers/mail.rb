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

# override do_start from action_mailer_tls gem to work with JRuby
if defined?(JRUBY_VERSION)
  Net::SMTP.class_eval do
    private
    def do_start(helodomain, user, secret, authtype)
      raise IOError, 'SMTP session already started' if @started

      # this is the method that fails in JRuby unless the authtype is passed as well
      check_auth_args user, secret, authtype if user or secret

      sock = timeout(@open_timeout) { TCPSocket.open(@address, @port) }
      @socket = Net::InternetMessageIO.new(sock)
      @socket.read_timeout = 60 #@read_timeout

      check_response(critical { recv_response() })
      do_helo(helodomain)

      if starttls
        raise 'openssl library not installed' unless defined?(OpenSSL)
        ssl = OpenSSL::SSL::SSLSocket.new(sock)
        ssl.sync_close = true
        ssl.connect
        @socket = Net::InternetMessageIO.new(ssl)
        @socket.read_timeout = 60 #@read_timeout
        do_helo(helodomain)
      end

      authenticate user, secret, authtype if user
      @started = true
    ensure
      unless @started
        # authentication failed, cancel connection.
        @socket.close if not @started and @socket and not @socket.closed?
        @socket = nil
      end
    end
  end
end