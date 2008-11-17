class HelpController < ApplicationController 
  def show
    template_name = "help/#{params[:controller_name]}_#{params[:action_name]}"
    render :layout => false, :template => template_name
  end
end