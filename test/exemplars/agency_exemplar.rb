class Agency 
  generator_for(:name, :start => 'Agency0') { |prev| prev.succ }
  generator_for(:code, :start => 'AG0') { |prev| prev.succ }
end
