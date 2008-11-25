# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_previous_location
    link_to previous_location, root_url
  end
  
  def render_tabs
    '<ul class="tabs">' + maybe_render_navigation_tabs + add_help_tab + '</ul>'
  end
  
  def maybe_render_navigation_tabs     
    begin
      output = render :partial => navigation_tabs_partial if navigation_tabs_partial
    rescue ActionView::MissingTemplate  
      # no partial found        
    end
    output || ''    
  end
  
  def add_help_tab
    url_options  = { :controller_name => controller.controller_name, :action_name => controller.action_name }
    html_options = { :id => 'help', :class => 'tab' }
    '<li class="help">' + 
      link_to('Help', show_help_path(url_options), html_options) +
      '</li>'
  end  
  
  def add_tab(label, options, html_options = {})
    add_html_class('tab', html_options)
    add_html_class('active', html_options) if controller.controller_name == options[:controller] && controller.action_name == options[:action] 
    "<li>" + link_to(label, options, html_options) + "</li>"
  end
  
  def stylesheets
    output = "\n<!-- BEGIN STYLESHEETS -->\n"
    included_stylesheets.each do |stylesheet_config|
      stylesheet, options = stylesheet_config
      output = output + stylesheet_link(stylesheet, options) + "\n"
    end
    if layout_specific_stylesheet = layout_stylesheet
      output += layout_specific_stylesheet + "\n"
    end
    if controller_specific_stylesheet = controller_stylesheet
      output += controller_specific_stylesheet + "\n"
    end
    if action_specific_stylesheet = action_stylesheet
      output += action_specific_stylesheet + "\n"
    end
    output += "<!-- END STYLESHEETS -->\n"
    output
  end

  def layout_stylesheet
    location = "#{controller.active_layout}.css"
    stylesheet_link_tag(location) if File.exists?("#{Rails.root}/public/stylesheets/#{location}")
  end
  
  def controller_stylesheet
    location = "#{controller.controller_name}/controller.css"
    stylesheet_link_tag(location) if File.exists?("#{Rails.root}/public/stylesheets/#{location}")
  end
  
  def action_stylesheet
    location = "#{controller.controller_name}/#{controller.action_name}.css"
    stylesheet_link_tag(location) if File.exists?("#{Rails.root}/public/stylesheets/#{location}")
  end
  
  def javascripts
    output = "\n<!-- BEGIN JAVASCRIPTS -->\n"
    if uses_gmap?
      output += '<script type="text/javascript" src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=' + ApiKey.get + '" /></script>' + "\n"
    end
    included_javascripts.collect do |javascript_config|
      javascript_config unless javascript_config[1][:lazy_load]
    end.compact.each do |javascript_config|      
      javascript, options = javascript_config      
      output = output + javascript_include(javascript, options) + "\n"
    end
    
    output += "<!-- END JAVASCRIPTS -->\n"
    output
  end
  
  def lazy_javascripts
    output = "\n<!-- BEGIN LAZY JAVASCRIPTS -->\n"
    included_javascripts.collect do |javascript_config|
      javascript_config if javascript_config[1][:lazy_load]
    end.compact.each do |javascript_config|      
      javascript, options = javascript_config      
      output = output + javascript_include(javascript, options) + "\n"
    end
    output += "<!-- END LAZY JAVASCRIPTS -->\n"
    output
  end
  
  private  
  def stylesheet_link(stylesheet, options)
    link_method = options[:merged] ? 'stylesheet_link_merged' : 'stylesheet_link_tag'
    link = send(link_method, stylesheet, asset_options(options))
    if condition = options[:conditional]
      link = "<!--[if #{condition}]> #{link} <![endif]-->"
    end
    link
  end
  
  def javascript_include(javascript, options)
    include_method = options[:merged] ? 'javascript_include_merged' : 'javascript_include_tag'    
    include = send(include_method, javascript, asset_options(options))
    if condition = options[:conditional]
      include = "<!--[if #{condition}]> #{include} <![endif]-->"
    end
    include
  end
  
  def asset_options(options)
    removable_options = [:merged, :lazy_load, :conditional]
    options.clone.delete_if { |key, value| removable_options.include?(key) }
  end
  
  def add_html_class(class_name, html_options = {})
    old_class = html_options[:class].to_s
    new_class = "#{old_class} #{class_name}"
    html_options[:class] = new_class.strip
  end
end
