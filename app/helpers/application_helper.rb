# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def gmap_scripts
    scripts = GMap.header.split('</script>').collect{ |script_tag| script_tag.match(/<script.*src="(.*)"[^>]*/)[1] }
  end
end
