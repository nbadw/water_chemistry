class HelpController < ApplicationController 
  def show    
    template_name = "help/#{params[:controller_name]}/#{params[:action_name]}"
    begin
      render :layout => false, :template => template_name
    rescue ActionView::MissingTemplate
      render :layout => false, :text => "Sorry, no help could be found."
    end
  end
end