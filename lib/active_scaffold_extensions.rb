require 'active_scaffold_extensions/tooltips'

ActiveScaffold::DataStructures::Column.class_eval do
  include ActiveScaffoldExtensions::Tooltips
end