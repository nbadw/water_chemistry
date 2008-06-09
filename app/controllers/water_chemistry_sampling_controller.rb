class WaterChemistrySamplingController < ApplicationController
  def show
    redirect_to :action => 'activity_details', :id => params[:id]
  end
  
  def edit
    redirect_to :action => 'samples', :id => params[:id]
  end
  
  def samples   
    @aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_site
  end
  
  def activity_details
    @aquatic_activity = TblAquaticActivity.find params[:id], :include => :aquatic_site
  end
  
  def observations
    
  end
  
  private 
  def locate_template
    return full_path if template_exists? full_path
  end
end
