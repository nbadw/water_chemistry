class Demo::ApplicationController < ApplicationController    
  def login
    render :layout => false
  end

  def activities
    logger.debug "displaying activities demo screen"
    #@agency = Agency.find(:agency_code)
    lorem_ipsum = %q(Lorem ipsum dolor sit amet, consectetuer adipiscing elit. 
Duis consequat, lacus eu molestie sagittis, est nunc facilisis nisi, eu dapibus 
elit enim et quam. Pellentesque justo mauris, congue eu, ultricies quis, 
consequat mattis, purus. Cras suscipit fermentum erat. Nam in purus at enim 
ultrices vehicula. Aliquam a ligula. Ut vel dolor.)
    @activities = [
      Activity.new(:title => 'Demo Activity #1', :desc => lorem_ipsum,
        :author => 'Colin Casey', :updated_at => DateTime.now, :type => 'WaterChemistry'),
      Activity.new(:title => 'Demo Activity #2', :desc => lorem_ipsum,
        :author => 'Colin Casey', :updated_at => DateTime.now, :type => 'Electrofishing'),
      Activity.new(:title => 'Demo Activity #3', :desc => lorem_ipsum,
        :author => 'Colin Casey', :updated_at => DateTime.now, :type => 'WaterChemistry')
    ]
  end

  def activity
    @tasks = tasks
    render :layout => 'demo/activity'
  end

  def choose_site
    @tasks = tasks
    @current_task = 1
    render :layout => 'demo/activity'
  end

  def enter_measurements    
    @tasks = tasks
    @current_task = 2
    render :layout => 'demo/activity'
  end
  
  def another_step
    @tasks = tasks
    @current_task = 3
    render :layout => 'demo/activity'
  end
  
  def select_site
    render :layout => false
  end
  
  private
  def tasks
    @tasks = [
      Task.new(:title => 'Site Measurements', :controller => 'demo/application', :action => 'enter_measurements'),
      Task.new(:title => 'Water Measurements', :controller => 'demo/application', :action => 'enter_measurements'),
      Task.new(:title => 'Environmental Observations', :controller => 'demo/application', :action => 'another_step'),
      Task.new(:title => 'General Details (date, method)', :controller => 'demo/application', :action => 'another_step'),
      Task.new(:title => 'Lab Results', :controller => 'demo/application', :action => 'another_step')
    ]
    @tasks.each_index do |i|
      t = @tasks[i]
      t.id = i
      t.position = i + 1
      t.url = url_for(:controller => t.controller, :action => t.action)
    end    
  end
end
