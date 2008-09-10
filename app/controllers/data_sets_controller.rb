class DataSetsController < ApplicationController
  before_filter :find_aquatic_site
  
  def index
    render :text => 'test'
  end  
end
