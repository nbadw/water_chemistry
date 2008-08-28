class Agency 
  generator_for :name => 'AgencyName'
  generator_for(:code, :start => 'AG0') { |prev| prev.succ }
end
