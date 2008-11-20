module HelpHelper
  def help_section(title, &block)
    html = '<h4 class="help-section"><span class="status">+</span> <a href="javascript:void(0)">' + title + '</a></h4>'
    html += "\n" + '<div style="display: none;">' + "\n"
    html += capture(&block)
    html += "\n</div>\n"
    concat(html, block.binding)
  end
end
