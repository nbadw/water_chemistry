class User
  generator_for(:login, :start => 'user0') { |prev| prev.succ }
  generator_for(:email, :start => 'email0@test.com') do |prev|
    user, domain = prev.split('@')
    user.succ + '@' + domain
  end
  generator_for(:password, :start => 'password0') { |prev| prev.succ }
  generator_for(:password_confirmation, :start => 'password0') { |prev| prev.succ }
end
