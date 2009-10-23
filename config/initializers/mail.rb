require "smtp_tls"

config_file = "#{RAILS_ROOT}/config/smtp_gmail.yml"
raise "Sorry, you must have #{config_file}" unless File.exists?(config_file)
config_options = YAML.load_file(config_file)

# Email settings
if RAILS_ENV == 'production'
  ActionMailer::Base.delivery_method = :sendmail
else
  ActionMailer::Base.delivery_method = :smtp
end
# Use the following account for email delivery
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}.merge(config_options) # Configuration options override default options

# Net::SMTP has a different check_auth_args on 1.8.5
if RUBY_VERSION == '1.8.5'
  Net::SMTP.class_eval do
    private
    def do_start(helodomain, user, secret, authtype)
      raise IOError, 'SMTP session already started' if @started
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