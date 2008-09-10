module ActiveScaffoldExtensions
  module Tooltips      
    attr_writer :tooltip
    def tooltip
      as_(@tooltip) if @tooltip
    end    
  end
end
